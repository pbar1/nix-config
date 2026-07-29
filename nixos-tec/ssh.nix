{
  config,
  lib,
  pkgs,
  ...
}:

let
  foo = null;
in

{
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.KexAlgorithms = [
    "mlkem768x25519-sha256"
    "sntrup761x25519-sha512"
    "sntrup761x25519-sha512@openssh.com"
    "curve25519-sha256"
    "curve25519-sha256@libssh.org"
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
  '';

  users.users."nixos".openssh.authorizedKeys.keys = [
    "verify-required sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHxrK0/YVAOMW+IKh7TPw8URtahQEEhcmu2q64i+ckzOAAAABHNzaDo= yubikey"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBOdw035S5U0YP971KASp1NFK3BR2vmEflQxzn5ECwY4HEsiCfMQr20bo2JI47M/E6BVK/38AdEcixjESUYNQm7s= bobbery"
  ];
}
