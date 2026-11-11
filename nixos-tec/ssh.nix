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
  # Must enable at least one MAC, even though none will be used due to only
  # AEAD ciphers being enabled
  services.openssh.settings.Macs = [
    "hmac-sha2-256-etm@openssh.com"
  ];
  services.openssh.extraConfig = ''
    HostKeyAlgorithms ssh-ed25519
    PubkeyAcceptedAlgorithms +ssh-mldsa44-ed25519
  '';

  security.pam.rssh.settings.auth_key_file = "/etc/ssh/sudo_authorized_keys";
  # pam_rssh ignores authorized_keys options; verification depends on the key and agent.
  environment.etc."ssh/sudo_authorized_keys".text = ''
    ${sshKeys.yubikey}
    ${sshKeys.bobbery}
  '';

  users.users."nixos".openssh.authorizedKeys.keys = [
    "verify-required ${sshKeys.yubikey}"
    sshKeys.bobbery
    sshKeys.goombella
    sshKeys.koops
  ];
}
