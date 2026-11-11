{ ... }:

let
  sshKeys = import ../data/ssh-keys.nix;
in

{
  services.openssh.enable = true;
  services.openssh.authorizedKeysInHomedir = false;
  services.openssh.settings.AllowUsers = [ "nixos" ];
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.KexAlgorithms = [
    "mlkem768x25519-sha256"
    "sntrup761x25519-sha512"
    "sntrup761x25519-sha512@openssh.com"
  ];
  services.openssh.settings.Ciphers = [
    "chacha20-poly1305@openssh.com"
    "aes256-gcm@openssh.com"
  ];
  # Must enable at least one MAC. It will not be used since only AEAD ciphers
  # are enabled, and they skip MAC.
  services.openssh.settings.Macs = [
    "hmac-sha2-256-etm@openssh.com"
  ];
  services.openssh.extraConfig = ''
    HostKeyAlgorithms ssh-ed25519
    PubkeyAcceptedAlgorithms +ssh-mldsa44-ed25519
  '';

  users.users."nixos".openssh.authorizedKeys.keys = [
    "verify-required ${sshKeys.yubikey}"
    sshKeys.bobbery
    sshKeys.goombella
    sshKeys.koops
  ];

  # TODO: Delete this when pam_rssh supports options like `verify-required`
  security.pam.rssh.settings.auth_key_file = "/etc/ssh/sudo_authorized_keys";
  environment.etc."ssh/sudo_authorized_keys".text = ''
    ${sshKeys.yubikey}
    ${sshKeys.bobbery}
    ${sshKeys.goombella}
    ${sshKeys.koops}
  '';
}
