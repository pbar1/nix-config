{ config, ... }:

{
  boot.initrd.systemd.enable = true;
  boot.initrd.kernelModules = [ "vmw_vmci" "vmw_vsock_vmci_transport" ];

  # Reuse NixOS's initrd SSH configuration and secrets, with a vsock listener.
  boot.initrd.network.enable = true;
  boot.initrd.systemd.network.enable = false;
  boot.initrd.network.ssh.enable = true;
  boot.initrd.network.ssh.hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
  boot.initrd.network.ssh.authorizedKeys = [
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLkffON6Kk0FS/6PkC7VINKFiQuJuxiHKwFXRBFBgUjMCvKJ+cAv1rutMSLYdqtaSOhMdfaQDv23oeSzAoPZF8Y= bobbery"
  ];
  boot.initrd.network.ssh.extraConfig = ''
    PermitRootLogin prohibit-password
    AuthenticationMethods publickey
    AllowUsers root
    DisableForwarding yes
    ForceCommand /bin/systemd-tty-ask-password-agent --watch
  '';

  boot.initrd.systemd.extraBin.systemd-tty-ask-password-agent =
    "${config.boot.initrd.systemd.package}/bin/systemd-tty-ask-password-agent";
  boot.initrd.systemd.services.sshd.enable = false;

  boot.initrd.systemd.sockets.sshd-vsock = {
    description = "SSH disk unlocking over VMware vsock";
    wantedBy = [ "initrd.target" ];
    requires = [ "systemd-modules-load.service" "initrd-nixos-copy-secrets.service" ];
    after = [ "systemd-modules-load.service" "initrd-nixos-copy-secrets.service" ];
    before = [ "shutdown.target" ];
    conflicts = [ "shutdown.target" ];
    unitConfig.DefaultDependencies = false;
    socketConfig.ListenStream = "vsock::22";
    socketConfig.Accept = true;
  };

  boot.initrd.systemd.services."sshd-vsock@" = {
    description = "SSH disk-unlock connection";
    after = [ "initrd-nixos-copy-secrets.service" ];
    before = [ "shutdown.target" ];
    conflicts = [ "shutdown.target" ];
    unitConfig.DefaultDependencies = false;
    preStart = "/bin/chmod 0600 /etc/secrets/initrd/ssh_host_ed25519_key";
    serviceConfig.ExecStart = "-${config.programs.ssh.package}/bin/sshd -i -e -f /etc/ssh/sshd_config";
    serviceConfig.StandardInput = "socket";
    serviceConfig.StandardOutput = "socket";
    serviceConfig.StandardError = "journal";
  };
}
