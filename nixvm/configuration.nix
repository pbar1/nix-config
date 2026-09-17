{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./unlock.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  fileSystems."/boot".options = lib.mkForce [ "fmask=0077" "dmask=0077" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  networking.hostName = "nixvm";
  networking.networkmanager.enable = true;
  networking.networkmanager.insertNameservers = [ "1.1.1.1" "8.8.8.8" ];
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.user.isNormalUser = true;
  users.users.user.extraGroups = [ "wheel" "networkmanager" ];
  users.users.user.openssh.authorizedKeys.keys = config.boot.initrd.network.ssh.authorizedKeys;
  users.users.root.hashedPassword = "!";
  security.sudo.wheelNeedsPassword = true;

  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = false;
  services.displayManager.sddm.settings = {
    General.GreeterEnvironment = "QT_SCALE_FACTOR=2";
    Theme.CursorSize = 48;
  };
  services.xserver.videoDrivers = [ "modesetting" ];
  services.displayManager.defaultSession = "plasmax11";
  services.displayManager.autoLogin = {
    enable = true;
    user = "user";
  };
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "colemak";
  console.useXkbConfig = true;
  console.earlySetup = true;
  environment.systemPackages = [ pkgs.firefox pkgs.ghostty ];

  # System-wide Plasma configuration; per-user configuration takes precedence.
  environment.etc."xdg/kdeglobals".text = ''
    [General]
    BrowserApplication=firefox.desktop
    [KScreen]
    ScaleFactor=2
    ScreenScaleFactors=Virtual-1=2;
    [KDE]
    AutomaticLookAndFeel=true
  '';
  environment.etc."xdg/kcmfonts".text = ''
    [General]
    forceFontDPI=192
  '';
  environment.etc."xdg/kcminputrc".text = ''
    [Mouse]
    cursorTheme=breeze_cursors
    cursorSize=48
  '';
  environment.etc."xdg/kscreenlockerrc".text = ''
    [Daemon]
    Autolock=false
    LockOnResume=false
  '';
  environment.etc."xdg/powerdevilrc".text = lib.concatMapStrings (profile: ''
    [${profile}][Display]
    DimDisplayWhenIdle=false
    TurnOffDisplayWhenIdle=false
    [${profile}][SuspendAndShutdown]
    AutoSuspendAction=0
  '') [ "AC" "Battery" "LowBattery" ];

  virtualisation.vmware.guest.enable = true;
  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.pulse.enable = true;
  # Use 16-bit samples so VMware's audio buffer holds enough frames.
  services.pipewire.wireplumber.extraConfig."50-vmware-audio"."monitor.alsa.rules" = [
    {
      matches = [ { "node.name" = "alsa_output.pci-0000_01_01.0.analog-stereo"; } ];
      actions.update-props."audio.format" = "S16LE";
    }
  ];

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.KbdInteractiveAuthentication = false;
  services.openssh.settings.PermitRootLogin = "no";

  swapDevices = [ { device = "/var/lib/swapfile"; size = 4096; } ];
  system.stateVersion = "26.05";
}
