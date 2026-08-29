{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (config.home) homeDirectory;

  toTOML = (pkgs.formats.toml { }).generate "dummy";
  sshConfigEscape = s: lib.replaceStrings [ " " ] [ "\\ " ] s;
  secretiveData = "${homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data";
  sshAgentSecretive = "${secretiveData}/socket.ssh";
  sshAgent1Password = "${homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

  keyMain = "${secretiveData}/PublicKeys/f147e7312171443c2e0557320e1ce2a9.pub";
  keyGit = "${homeDirectory}/.ssh/git.pub";
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
      identityFile = keyMain;
      identitiesOnly = true;
    };
    "github.com" = {
      user = "git";
      hostname = "github.com";
      identityAgent = lib.mkIf isDarwin (sshConfigEscape sshAgent1Password);
      identityFile = keyGit;
    };
    "tec" = {
      user = "nixos";
      hostname = "10.0.0.54";
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
