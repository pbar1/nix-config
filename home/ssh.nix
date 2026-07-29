{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv) isDarwin;
  inherit (config.home) homeDirectory;

  toTOML = (pkgs.formats.toml { }).generate "dummy";
  sshConfigEscape = s: lib.replaceStrings [ " " ] [ "\\ " ] s;
  secretiveData = "${homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data";
  sshAgentSecretive = "${secretiveData}/socket.ssh";
  sshAgent1Password = "${homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

  sshAgentMain = if isDarwin then sshAgentSecretive else null;
  sshAgentGit = if isDarwin then sshAgent1Password else null;

  pubkeyMain = "${secretiveData}/PublicKeys/2417d563ece4afe286bc273c01b3a1b1.pub";
  pubkeyGit = "${homeDirectory}/.ssh/git.pub";
in

{
  # Select a subset of keys from 1Password agent and set their ordering
  xdg.configFile."1Password/ssh/agent.toml".source = toTOML {
    ssh-keys = [ { item = "SSH Git"; } ];
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = sshAgentMain;
    SSH_AGENT_PID = "";
  };

  programs.ssh.enable = true;
  programs.ssh.enableDefaultConfig = false;
  programs.ssh.settings = {
    "*" = {
      identityAgent = sshConfigEscape sshAgentMain;
      identityFile = pubkeyMain;
      identitiesOnly = true;
    };
    "github.com" = {
      user = "git";
      hostname = "github.com";
      identityAgent = sshConfigEscape sshAgentGit;
      identityFile = pubkeyGit;
    };
    "tec" = {
      user = "nixos";
      hostname = "tec";
    };
    "ha" = {
      user = "root";
      hostname = "yellow";
    };
    "haos" = {
      user = "root";
      hostname = "yellow";
      port = 22222;
    };
    "kindle" = {
      user = "root";
      hostname = "10.21.20.194";
      port = 2222;
    };
  };
}
