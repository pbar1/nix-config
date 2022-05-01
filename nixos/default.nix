{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
  ];

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.binaryCaches = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
    "https://pbar1.cachix.org"
  ];
  nix.binaryCachePublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
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

  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "pierce";
  services.xserver.xkbOptions = "caps:escape";
  services.xserver.autoRepeatDelay = 150;
  services.xserver.autoRepeatInterval = 15;
  services.xserver.libinput.enable = true;

  # Disable sound module as it conflicts with PipeWire
  sound.enable = false;
  hardware.pulseaudio.enable = false;

  # Enable PipeWire for sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Uncomment this line to allow AirPods to connect. After initial connection,
  # it can be commented back out (ie, ControllerMode = "dual").
  # See: https://github.com/tim-hilt/nixos/blob/main/config/desktop.nix
  # hardware.bluetooth.settings = { General = { ControllerMode = "bredr"; }; };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pierce = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "docker" "libvirtd" ];
  };
  users.users.root.hashedPassword = "!"; # Disable root user

  # Unlock GNOME keyring on login
  security.pam.services.gdm.enableGnomeKeyring = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # For systray icons
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

  services.tailscale.enable = true;

  virtualisation = {
    # https://adamsimpson.net/writing/windows-11-as-kvm-guest
    libvirtd.enable = true;
    libvirtd.qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        package = pkgs.OVMFFull.override {
          secureBoot = true;
          tpmSupport = true;
        };
      };
    };

    docker = {
      enable = true;
      autoPrune.enable = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
