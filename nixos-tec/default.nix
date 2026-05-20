{ pkgs, ... }:

let
  apiServerHost = "10.0.0.54";
  zfsMount = [ "zfs-mount.service" ];
in

{
  imports = [
    ./apparmor
    ./hardware-configuration.nix
    ./home.nix
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

  networking.hostName = "tec";
  networking.hostId = "e7e35d28"; # via `head -c 8 /etc/machine-id`
  networking.firewall.allowedTCPPorts = [
    2022 # Eternal Terminal
    6443 # Kubernetes - API
    10250 # Kubernetes - Metrics Server
    32400 # Plex
  ];
  networking.firewall.logReversePathDrops = true;
  networking.firewall.extraCommands = ''
    ${pkgs.iptables}/bin/iptables -t mangle -C nixos-fw-rpfilter -i lxc+ -s 10.42.0.0/16 -m comment --comment "Cilium pod veth rpfilter bypass" -j RETURN 2>/dev/null \
      || ${pkgs.iptables}/bin/iptables -t mangle -I nixos-fw-rpfilter 1 -i lxc+ -s 10.42.0.0/16 -m comment --comment "Cilium pod veth rpfilter bypass" -j RETURN
    ${pkgs.iptables}/bin/iptables -C nixos-fw -i lxc+ -s 10.42.0.0/16 -p tcp --dport 4244 -m comment --comment "Cilium Hubble peer from pods" -j nixos-fw-accept 2>/dev/null \
      || ${pkgs.iptables}/bin/iptables -I nixos-fw 3 -i lxc+ -s 10.42.0.0/16 -p tcp --dport 4244 -m comment --comment "Cilium Hubble peer from pods" -j nixos-fw-accept
  '';
  networking.firewall.extraStopCommands = ''
    ${pkgs.iptables}/bin/iptables -t mangle -D nixos-fw-rpfilter -i lxc+ -s 10.42.0.0/16 -m comment --comment "Cilium pod veth rpfilter bypass" -j RETURN 2>/dev/null || true
    ${pkgs.iptables}/bin/iptables -D nixos-fw -i lxc+ -s 10.42.0.0/16 -p tcp --dport 4244 -m comment --comment "Cilium Hubble peer from pods" -j nixos-fw-accept 2>/dev/null || true
  '';

  time.timeZone = "America/Los_Angeles";

  users.users.nixos.isNormalUser = true;
  users.users.nixos.extraGroups = [ "wheel" ];
  users.users.nixos.hashedPassword = "$6$ouPdfmFbwMP/0uf7$qHv26BknhOYNzoZPMJZ6Ic5uR6Rw3K/CLSYEDWr5djV9UJKkzcGB4b3ZRqHawJ5pt.dKr3ySK7JDUyTnXEl2k1";
  users.users.nixos.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO00lZvj7Xhb8SqwW/2VFDxg6SOD4GdAjsmX75txEn6p nix_build@1password"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvmdvrrgYY3Q+Wp/SyQm2a2OWL82S2Z+e+FoJ/vmS/D personal@1password"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBeL5XO0CnwlYNUX+4OXnLBLXzbYsOjLYp7TtJpjrn9QpnrIo/zUDp0HZifnauOyVln9+GvqiMyB4xqfYhUhRjg= blink@goombella"
  ];

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
    yt-dlp
  ];

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.KexAlgorithms = [
    "mlkem768x25519-sha256"
    "sntrup761x25519-sha512"
    "sntrup761x25519-sha512@openssh.com"
    "curve25519-sha256"
    "curve25519-sha256@libssh.org"
  ];
  services.openssh.settings.Ciphers = [
    "chacha20-poly1305@openssh.com"
    "aes256-gcm@openssh.com"
  ];
  services.openssh.settings.Macs = [
    "hmac-sha2-256-etm@openssh.com" # must enable at least one
  ];
  services.openssh.extraConfig = ''
    HostKeyAlgorithms ssh-ed25519
  '';

  services.eternal-terminal.enable = true;
  programs.mosh.enable = true;

  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    # IPv4-only because ISP has trouble keeping an IPv6 address, which crashes
    # the cluster when lost
    "--cluster-cidr=10.42.0.0/16"
    "--service-cidr=10.43.0.0/16"
    "--default-local-storage-path=/zssd/general/local-path-provisioner"
    "--secrets-encryption"
    "--disable=traefik"
    "--disable=servicelb"
    "--disable-kube-proxy"
    "--disable-network-policy"
    "--flannel-backend=none"
  ];
  services.k3s.manifests.cilium.content = {
    apiVersion = "helm.cattle.io/v1";
    kind = "HelmChart";
    metadata.name = "cilium";
    metadata.namespace = "kube-system";
    spec.chart = "oci://quay.io/cilium/charts/cilium";
    spec.version = "1.19.4";
    spec.targetNamespace = "kube-system";
    spec.bootstrap = true;
    spec.valuesContent = ''
      operator:
        replicas: 1

      kubeProxyReplacement: true
      k8sServiceHost: "${apiServerHost}"
      k8sServicePort: 6443

      ipam:
        operator:
          clusterPoolIPv4PodCIDRList:
            - 10.42.0.0/16

      cni:
        binPath: /opt/cni/bin
        confPath: /etc/cni/net.d

      routingMode: tunnel
      tunnelProtocol: vxlan

      hubble:
        enabled: true
        relay:
          enabled: true
        ui:
          enabled: true
    '';
  };
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

    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.kata]
      runtime_type = "io.containerd.kata.v2"
      privileged_without_host_devices = true
      pod_annotations = ["io.katacontainers.*"]
      container_annotations = ["io.katacontainers.*"]
  '';
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
