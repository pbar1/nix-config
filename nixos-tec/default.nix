{ pkgs, ... }:

{
  imports = [
    ./apparmor
    ./hardware-configuration.nix
    ./home.nix
    ./k8s
    ./ssh.nix
  ];

  system.stateVersion = "22.05";

  nix.settings.substituters = [
    "https://nix-community.cachix.org"
    "https://pbar1.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "pbar1.cachix.org-1:DsBqAi4CnR7TaABRn59sUBBK+lofYhQaV8lK8nl2gow="
  ];
  nix.settings.trusted-users = [ "root" ];
  nix.settings.allowed-users = [
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

  users.mutableUsers = false;
  users.users.root.hashedPassword = "!"; # Disable root user
  users.users.nixos.hashedPasswordFile = "/var/lib/secrets/nixos-password";
  users.users.nixos.isNormalUser = true;
  users.users.nixos.extraGroups = [ "wheel" ];

  security.sudo-rs.enable = true;
  security.sudo-rs.wheelNeedsPassword = true;
  security.sudo-rs.execWheelOnly = true;
  security.pam.rssh.enable = true;
  security.pam.services.sudo.rssh = true;
  security.pam.services.sudo-i.rssh = true;

  environment.systemPackages = with pkgs; [
    bpftrace
    btop
    fd
    ffmpeg
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
}
