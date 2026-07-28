{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv) isDarwin;
  inherit (config.home) homeDirectory;

  secretiveData = "${homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data";
  pubkeyAuth = "${secretiveData}/PublicKeys/2417d563ece4afe286bc273c01b3a1b1.pub";
  pubkeyGit = "${secretiveData}/PublicKeys/2a01d39e9725b0c9e5b5e62a8c951393.pub";
  sshAgentSocket = if isDarwin then "${secretiveData}/socket.ssh" else null;

  identityAgent = lib.replaceStrings [ " " ] [ "\\ " ] sshAgentSocket;
in

{
  home.sessionVariables = {
    SSH_AUTH_SOCK = sshAgentSocket;
    SSH_AGENT_PID = "";
  };

  programs.ssh.enable = true;
  programs.ssh.enableDefaultConfig = false;
  programs.ssh.settings = {
    "*" = {
      inherit identityAgent;
    };
    "github.com" = {
      user = "git";
      hostname = "github.com";
      identityFile = pubkeyGit;
      identitiesOnly = true;
    };
    "tec" = {
      user = "nixos";
      hostname = "tec";
      identityFile = pubkeyAuth;
      identitiesOnly = true;
    };
    "ha" = {
      user = "root";
      hostname = "yellow";
      identityFile = pubkeyAuth;
      identitiesOnly = true;
    };
    "haos" = {
      user = "root";
      hostname = "yellow";
      port = 22222;
      identityFile = pubkeyAuth;
      identitiesOnly = true;
    };
  };
}
