{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
  ];

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.settings.substituters = [
    "https://nix-community.cachix.org"
    "https://pbar1.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "pbar1.cachix.org-1:DsBqAi4CnR7TaABRn59sUBBK+lofYhQaV8lK8nl2gow="
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  # Create Btrfs-compatible swapfile
  # https://github.com/NixOS/nixpkgs/issues/91986#issuecomment-787143060
  systemd.services.create-swapfile = {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "swap-swapfile.swap" ];
    script = ''
      ${pkgs.e2fsprogs}/bin/chattr +C /swap
      ${pkgs.coreutils}/bin/truncate -s 0 /swap/swapfile
      ${pkgs.btrfs-progs}/bin/btrfs property set /swap/swapfile compression none
      ${pkgs.btrfs-progs}/bin/btrfs property set /swap/swapfile noautodefrag
      ${pkgs.btrfs-progs}/bin/btrfs property set /swap/swapfile nodiscard
    '';
  };

  i18n.defaultLocale = "en_US.UTF-8";

  fonts.fonts = with pkgs; [
    noto-fonts-cjk
    twitter-color-emoji
  ];
  fonts.fontconfig.defaultFonts.emoji = [ "Twitter Color Emoji" ];

  services.xserver.autoRepeatDelay = 150;
  services.xserver.autoRepeatInterval = 15;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "pierce";
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.enable = true;
  services.xserver.libinput.enable = true;
  services.xserver.xkbOptions = "caps:escape";

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Disable sound module as it conflicts with PipeWire
  sound.enable = false;
  hardware.pulseaudio.enable = false;

  # Enable PipeWire for sound
  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.pulse.enable = true;

  # Uncomment this line to allow AirPods to connect. After initial connection,
  # it can be commented back out (ie, ControllerMode = "dual").
  # See: https://github.com/tim-hilt/nixos/blob/main/config/desktop.nix
  # hardware.bluetooth.settings = { General = { ControllerMode = "bredr"; }; };
  hardware.bluetooth.enable = true;

  networking.networkmanager.enable = true;

  users.users.pierce.isNormalUser = true;
  users.users.pierce.shell = pkgs.fish;
  users.users.pierce.extraGroups = [
    "wheel"
    "networkmanager"
    "libvirtd"
  ];
  users.users.root.hashedPassword = "!"; # Disable root user

  security.pam.services.gdm.enableGnomeKeyring = true;
  security.sudo.wheelNeedsPassword = false;
  security.apparmor.enable = true;

  services.eternal-terminal.enable = true;
  services.eternal-terminal.port = 2022;
  services.openssh.enable = true;
  services.openssh.settings.permitRootLogin = "no";
  services.tailscale.enable = true;
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  programs.dconf.enable = true;
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;
  programs.gpaste.enable = true;

  networking.firewall.allowedTCPPorts = [ 2022 ];
  networking.firewall.checkReversePath = "loose";

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.onBoot = "ignore";
  virtualisation.libvirtd.qemu.ovmf.enable = true;
  # If this was previously set to another value, it needed a `nix-collect-garbage`
  # clear the conflicting OVMF packages and links. Also, the trailing `.fd` is
  # crucial - without it, the links are all broken.
  virtualisation.libvirtd.qemu.ovmf.packages = [
    (pkgs.OVMFFull.override {
      secureBoot = true;
      tpmSupport = true;
    }).fd
  ];
  virtualisation.libvirtd.qemu.runAsRoot = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;
  virtualisation.podman.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
