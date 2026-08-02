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
  sshAgent1Password = "${homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

  sshAgentGit = if isDarwin then sshAgent1Password else null;

  sshSkProvider = if isDarwin then "/usr/lib/ssh-keychain.dylib" else null;

  keyMain = "${homeDirectory}/.ssh/id_ecdsa_sk_rk";
  keyGit = "${homeDirectory}/.ssh/git.pub";
in

{
  # Select a subset of keys from 1Password agent and set their ordering
  xdg.configFile."1Password/ssh/agent.toml".source = toTOML {
    ssh-keys = [ { item = "SSH Git"; } ];
  };

  home.sessionVariables = {
    SSH_AGENT_PID = "";
    SSH_SK_PROVIDER = sshSkProvider;
  };

  programs.ssh.enable = true;
  programs.ssh.enableDefaultConfig = false;
  programs.ssh.settings = {
    "*" = {
      securityKeyProvider = sshSkProvider;
      identityFile = keyMain;
      identitiesOnly = true;
    };
    "github.com" = {
      user = "git";
      hostname = "github.com";
      identityAgent = sshConfigEscape sshAgentGit;
      identityFile = keyGit;
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
