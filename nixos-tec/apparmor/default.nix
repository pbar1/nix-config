{ pkgs, ... }:

{
  # TODO: K3s containerd checks for /sbin/apparmor_parser to enable AppArmor
  systemd.tmpfiles.rules = [
    "d /sbin 0755 root root -"
    "L+ /sbin/apparmor_parser - - - - ${pkgs.apparmor-parser}/bin/apparmor_parser"
  ];

  security.apparmor.enable = true;

  security.apparmor.policies.sshd = {
    state = "complain";
    profile = import ./sshd.nix;
  };
  security.apparmor.policies.sshd-session = {
    state = "complain";
    profile = import ./sshd-session.nix;
  };
  security.apparmor.policies.sshd-auth = {
    state = "complain";
    profile = import ./sshd-auth.nix;
  };
  security.apparmor.policies.sftp-server = {
    state = "complain";
    profile = import ./sftp-server.nix;
  };

  security.apparmor.policies.plex = {
    state = "complain";
    profile = import ./plex.nix;
  };
}
