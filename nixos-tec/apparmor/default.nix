{ pkgs, ... }:

{
  # TODO: K3s containerd checks for /sbin/apparmor_parser to enable AppArmor
  systemd.tmpfiles.rules = [
    "d /sbin 0755 root root -"
    "L+ /sbin/apparmor_parser - - - - ${pkgs.apparmor-parser}/bin/apparmor_parser"
  ];

  security.apparmor.enable = true;

  security.apparmor.policies.plex = {
    state = "complain";
    profile = import ./plex.nix;
  };
}
