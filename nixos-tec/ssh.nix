{ ... }:

{
  services.openssh.enable = true;
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
    PubkeyAcceptedAlgorithms +ssh-mldsa44-ed25519@openssh.com
  '';

  # `verify-required` does not work with Secure Enclave sk keys
  users.users."nixos".openssh.authorizedKeys.keys = [
    "verify-required sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIHxrK0/YVAOMW+IKh7TPw8URtahQEEhcmu2q64i+ckzOAAAABHNzaDo= yubikey"
    "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBApCSzgxq+ze86XaLEBECN8rbtUK0COBJ/DTP4gzpwFJ443yqGL3XcT+n1X0RSYbiMllOP0FhZEo47FgP1oDyxQAAAAEc3NoOg== bobbery"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLkffON6Kk0FS/6PkC7VINKFiQuJuxiHKwFXRBFBgUjMCvKJ+cAv1rutMSLYdqtaSOhMdfaQDv23oeSzAoPZF8Y= bobbery"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBMaNwRzHuSDEwQXezB9qmmqEujhc+tx923ovtmb6boMlwcAG53z17ofNJshZlnEo3NbEbVmbLMOKglY0TNPDyhA= goombella"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBDrF2mGkbfDEZe22CyngsgbOYw9jZjfsK0eoBUH6zif2jzC66+9dc+T/yubOQkdZ1wMpGHWOCwlKmiylK7R4s0Y= koops"
  ];
}
