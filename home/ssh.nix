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

  opAgentMac = "${homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

  SSH_AUTH_SOCK = if isDarwin then opAgentMac else null;
  identityAgent = lib.replaceStrings [ " " ] [ "\\ " ] SSH_AUTH_SOCK;
in
{
  # Select subset of keys from 1Password agent and set their ordering
  xdg.configFile."1Password/ssh/agent.toml".source = toTOML {
    ssh-keys = [
      { item = "SSH Personal"; }
      { item = "SSH GitHub"; }
    ];
  };

  home.sessionVariables = {
    inherit SSH_AUTH_SOCK;
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
      identityFile = "~/.ssh/github.pub";
      identitiesOnly = true;
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
  };
}
