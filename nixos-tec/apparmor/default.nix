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

  # Capture AppArmor events without the kernel journal's printk rate limit.
  security.auditd.enable = true;
  security.auditd.settings = {
    max_log_file = 64;
    num_logs = 8;
    max_log_file_action = "ROTATE";
  };

  # Load profiles before setting the kernel's one-way lock_policy; K3s requires both.
  # Switches retain the loaded policy. Stage policy changes and dependent updates
  # with `task tec:boot`, then reboot; live rollback cannot revert policy.
  systemd.services.apparmor.reloadIfChanged = lib.mkForce false;
  systemd.services.apparmor.restartIfChanged = false;
  systemd.services.apparmor.serviceConfig.ExecReload = lib.mkForce [ ];
  systemd.services.apparmor.serviceConfig.ExecStop = lib.mkForce [ ];

  systemd.services.apparmor-policy-lock = {
    description = "Lock AppArmor policy until reboot";
    wantedBy = [ "sysinit.target" ];
    requiredBy = [ "k3s.service" ];
    requires = [ "apparmor.service" ];
    after = [ "apparmor.service" ];
    before = [
      "sysinit.target"
      "k3s.service"
    ];
    unitConfig.DefaultDependencies = false;
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
    script = ''
      if [ "$(cat /sys/module/apparmor/parameters/lock_policy)" != Y ]; then
        echo Y > /sys/module/apparmor/parameters/lock_policy
      fi
    '';
  };

  # WARNING: aa-remove-unknown runs and unloads undeclared runtime profiles
  # which removes confinement on live processes. killUnconfinedConfinables does
  # NOT mitigate this.
  security.apparmor.policies = {
    "cri-containerd.apparmor.d" = {
      state = "enforce";
      profile = builtins.readFile ./cri-containerd.apparmor.d;
    };
    kata-cloud-hypervisor = {
      state = "enforce";
      profile = import ./kata-cloud-hypervisor.nix;
    };
  };
}
