{
  config,
  lib,
  pkgs,
  ...
}:

let
  sshKeys = import ../data/ssh-keys.nix;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (config.home) homeDirectory;

  toTOML = (pkgs.formats.toml { }).generate "dummy";
  sshConfigEscape = s: lib.replaceStrings [ " " ] [ "\\ " ] s;
  secretiveData = "${homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data";
  sshAgentSecretive = "${secretiveData}/socket.ssh";
in

{
  # Select a subset of keys from 1Password agent and set their ordering
  xdg.configFile."1Password/ssh/agent.toml".source = toTOML {
    ssh-keys = [ { item = "SSH Git"; } ];
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = lib.mkIf isDarwin sshAgentSecretive;
    SSH_AGENT_PID = "";
  };

  programs.ssh.enable = true;
  programs.ssh.enableDefaultConfig = false;
  programs.ssh.settings = {
    "*" = {
      identityAgent = lib.mkIf isDarwin (sshConfigEscape sshAgentSecretive);
      identityFile = toString (pkgs.writeText "bobbery.pub" "${sshKeys.bobbery}\n");
      identitiesOnly = true;
    };
    "tec" = {
      user = "nixos";
      hostname = "tec";
      forwardAgent = true;
    };
    "ha" = {
      user = "root";
      hostname = "home-assistant";
    };
    "haos" = {
      user = "root";
      hostname = "home-assistant";
      port = 22222;
    };
    "kindle" = {
      user = "root";
      hostname = "10.21.20.194";
      port = 2222;
    };
  };
}
