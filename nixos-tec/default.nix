{ inputs, pkgs, ... }:

let
  apiServerHost = "10.0.0.54";
  zfsMount = [ "zfs-mount.service" ];
  runscConfig = pkgs.writeText "runsc.toml" ''
    [runsc_config]
      platform = "kvm"
      directfs = "false"
      oci-seccomp = "true"
      systemd-cgroup = "true"
  '';
  kataKernel = pkgs.runCommand "kata-kernel" { nativeBuildInputs = [ pkgs.zstd ]; } ''
    tar --zstd -xf ${inputs.kata-kernel} --wildcards './opt/kata/share/kata-containers/vmlinux*'
    cp -L opt/kata/share/kata-containers/vmlinux.container "$out"
  '';
  kataConfig = pkgs.runCommand "kata-clh.toml" { } ''
    substitute ${pkgs.kata-runtime}/share/defaults/kata-containers/configuration-clh.toml "$out" \
      --replace-fail "${pkgs.kata-runtime}/bin/cloud-hypervisor" "${pkgs.cloud-hypervisor}/bin/cloud-hypervisor" \
      --replace-fail 'kernel = "${pkgs.kata-runtime.kata-images}/share/kata-containers/vmlinux.container"' 'kernel = "${kataKernel}"' \
      --replace-fail 'enable_annotations = ["enable_iommu", "kernel_params", "kernel_verity_params"]' 'enable_annotations = []' \
      --replace-fail 'disable_guest_seccomp = true' 'disable_guest_seccomp = false' \
      --replace-fail 'reclaim_guest_freed_memory = false' 'reclaim_guest_freed_memory = true'
  '';
in

{
  imports = [
    ./apparmor
    ./hardware-configuration.nix
    ./home.nix
    ./ssh.nix
  ];

  nix.settings.substituters = [
    "https://nix-community.cachix.org"
    "https://pbar1.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "pbar1.cachix.org-1:DsBqAi4CnR7TaABRn59sUBBK+lofYhQaV8lK8nl2gow="
  ];
  nix.settings.trusted-users = [
    "root"
    "nixos"
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than=30d";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  networking.hostName = "tec";
  networking.hostId = "e7e35d28"; # via `head -c 8 /etc/machine-id`
  networking.firewall.allowedTCPPorts = [
    2022 # Eternal Terminal
    6443 # Kubernetes - API
    10250 # Kubernetes - Metrics Server
    30180 # WebDAV
    32400 # Plex
  ];

  time.timeZone = "America/Los_Angeles";

  users.users.nixos.isNormalUser = true;
  users.users.nixos.extraGroups = [ "wheel" ];
  users.users.nixos.hashedPassword = "$6$ouPdfmFbwMP/0uf7$qHv26BknhOYNzoZPMJZ6Ic5uR6Rw3K/CLSYEDWr5djV9UJKkzcGB4b3ZRqHawJ5pt.dKr3ySK7JDUyTnXEl2k1";

  users.users.root.hashedPassword = "!"; # Disable root user

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    bpftrace
    btop
    fd
    ffmpeg
    fselect
    ghostty.terminfo
    jq
    osc
    pv
    python3
    ripgrep
    ruby
    sd
    smartmontools
    tmux
    vim
    wget
  ];

  services.eternal-terminal.enable = true;
  programs.mosh.enable = true;

  services.tailscale.enable = true;
  services.tailscale.openFirewall = true;
  services.tailscale.disableTaildrop = true;
  services.tailscale.extraSetFlags = [
    "--accept-dns=false"
    "--ssh=false" # Insecure; ensure this never gets silently enabled
  ];

  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    # Keep IPv4 primary while using k3s's default IPv6 ranges.
    "--cluster-cidr=10.42.0.0/16,fd00:42::/56"
    "--service-cidr=10.43.0.0/16,fd00:43::/112"
    "--advertise-address=${apiServerHost}"
    "--flannel-ipv6-masq"
    "--default-local-storage-path=/zssd/general/local-path-provisioner"
    "--secrets-encryption"
    "--disable=traefik"
    "--disable=runtimes"
  ];
  services.k3s.manifests.gvisor-runtimeclass.content = {
    apiVersion = "node.k8s.io/v1";
    kind = "RuntimeClass";
    metadata.name = "gvisor";
    handler = "runsc";
  };
  services.k3s.manifests.kata-runtimeclass.content = {
    apiVersion = "node.k8s.io/v1";
    kind = "RuntimeClass";
    metadata.name = "kata";
    handler = "kata";
    overhead.podFixed.cpu = "25m";
    overhead.podFixed.memory = "256Mi";
  };
  services.k3s.containerdConfigTemplate = ''
    {{ template "base" . }}

    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runsc]
      runtime_type = "io.containerd.runsc.v1"

    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runsc.options]
      TypeUrl = "io.containerd.runsc.v1.options"
      ConfigPath = "${runscConfig}"

    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.kata]
      runtime_type = "io.containerd.kata.v2"
      privileged_without_host_devices = true
      pod_annotations = []
      container_annotations = []

    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.kata.options]
      ConfigPath = "${kataConfig}"
  '';
  systemd.services.k3s.restartTriggers = [ kataConfig ];
  systemd.services.k3s.path = with pkgs; [
    apparmor-parser
    apparmor-utils
    gvisor
    kata-runtime
  ];
  systemd.services.k3s.serviceConfig.DeviceAllow = [
    "/dev/kvm rwm"
    "/dev/kmsg rwm"
    "/dev/vhost-vsock rwm"
    "/dev/vhost-net rwm"
    "/dev/net/tun rwm"
  ];
  systemd.services.k3s.serviceConfig.Delegate = "yes";
  # Ensure K3s starts with proper ZFS datasets mounted
  systemd.services.k3s.after = zfsMount;
  systemd.services.k3s.requires = zfsMount;
  systemd.services.k3s.unitConfig.RequiresMountsFor = [
    "/data/media"
    "/data/torrents"
    "/zssd/general/config"
    "/zssd/general/local-path-provisioner"
  ];

  programs.criu.enable = true;

  system.stateVersion = "22.05";
}
