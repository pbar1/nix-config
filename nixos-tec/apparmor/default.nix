{ lib, pkgs, ... }:

let
  # NixOS does not install AppArmor tunables, enumerate and install them
  tunables = "${pkgs.apparmor-profiles}/etc/apparmor.d/tunables";
  readTunables =
    root:
    let
      go =
        dir:
        lib.concatMapAttrs (
          name: type:
          let
            path = "${dir}/${name}";
            rel = builtins.unsafeDiscardStringContext (lib.removePrefix "${root}/" path);
          in
          if type == "regular" then
            {
              "tunables/${rel}" = builtins.readFile path;
            }
          else if type == "directory" then
            go path
          else
            { }
        ) (builtins.readDir dir);
    in
    go root;
in

{
  # TODO: K3s containerd checks for /sbin/apparmor_parser to enable AppArmor
  systemd.tmpfiles.rules = [
    "d /sbin 0755 root root -"
    "L+ /sbin/apparmor_parser - - - - ${pkgs.apparmor-parser}/bin/apparmor_parser"
  ];

  security.apparmor.enable = true;
  security.apparmor.includes = readTunables tunables;

  security.apparmor.policies.plex = {
    state = "complain";
    profile = import ./plex.nix;
  };
}
