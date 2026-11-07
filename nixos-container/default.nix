{ modulesPath, pkgs, ... }:
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
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLkffON6Kk0FS/6PkC7VINKFiQuJuxiHKwFXRBFBgUjMCvKJ+cAv1rutMSLYdqtaSOhMdfaQDv23oeSzAoPZF8Y= bobbery@secretive"
  ];
  security.sudo.wheelNeedsPassword = false;
}
