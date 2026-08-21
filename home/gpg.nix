{ pkgs, ... }:

let
  pinentryPackage = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.pinentry_mac else null;
in
{
  programs.gpg.enable = false;

  services.gpg-agent.enable = false;
  services.gpg-agent.pinentry.package = pinentryPackage;
}
