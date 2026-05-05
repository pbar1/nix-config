{ pkgs, ... }:

let
  zfsMount = [ "zfs-mount.service" ];
in

{
  imports = [
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
  security.apparmor.enable = true;

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
  ];
  services.k3s.manifests.gvisor-runtimeclass.content = {
    apiVersion = "node.k8s.io/v1";
    kind = "RuntimeClass";
    metadata.name = "gvisor";
    handler = "runsc";
  };
  services.k3s.containerdConfigTemplate = ''
    {{ template "base" . }}

    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runsc]
      runtime_type = "io.containerd.runsc.v1"
  '';
  systemd.services.k3s.path = with pkgs; [
    apparmor-parser
    apparmor-utils
    gvisor
  ];
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
