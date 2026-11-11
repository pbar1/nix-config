{ modulesPath, pkgs, ... }:

let
  sshKeys = import ../data/ssh-keys.nix;
in

{
  imports = [ (modulesPath + "/profiles/docker-container.nix") ];

  system.stateVersion = "25.11";
  system.installer.channel.enable = false;
  installer.cloneConfig = false;

  networking.useDHCP = false;
  networking.firewall.enable = false;
  networking.resolvconf.enable = false;
  environment.etc."hosts".enable = false;
  environment.etc."hostname".enable = false;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.sandbox = false;

  # Keep cgroupfs writable without enabling nested controllers that break Kata exec.
  system.activationScripts.containerCgroup.text = "${pkgs.util-linux.mount}/bin/mount --options=remount,rw /sys/fs/cgroup";
  systemd.slices."-".sliceConfig.DisableControllers = [
    "cpu"
    "cpuset"
    "io"
    "memory"
    "pids"
  ];

  services.openssh.enable = true;
  services.openssh.settings.AuthenticationMethods = "publickey";
  services.openssh.settings.PermitRootLogin = "no";

  users.users.nixos.isNormalUser = true;
  users.users.nixos.extraGroups = [ "wheel" ];
  users.users.nixos.openssh.authorizedKeys.keys = [
    sshKeys.bobbery
  ];
  security.sudo.wheelNeedsPassword = false;
}
