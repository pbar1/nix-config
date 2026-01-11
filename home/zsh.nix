{
  config,
  lib,
  pkgs,
  ...
}:

let
  shellAliases = import ./shell/aliases.nix { inherit pkgs; };
  shellAbbrs = import ./shell/abbrs.nix;
in
{
  programs.zsh = {
    enable = true;

    dotDir = "${config.xdg.configHome}/zsh";
    enableVteIntegration = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    inherit shellAliases;
    zsh-abbr.enable = false; # Saw errors causing long shell startup
    zsh-abbr.abbreviations = shellAbbrs;

    # Flake inputs with prefix "zsh:" automatically end up here via overlay
    plugins = pkgs.lib.attrsets.mapAttrsToList (name: value: {
      inherit name;
      inherit (value) src;
    }) pkgs.myZshPlugins;

    loginExtra = lib.mkIf pkgs.stdenv.isDarwin ''
      # Non-POSIX-compliant shells (for example, fish) should not be set as user
      # login shell. Exec said shell here as a workaround if desired.
      if [[ $(ps -p $PPID -o comm=) != "fish" && -z $ZSH_EXECUTION_STRING ]]; then
          (( $+commands[fish] )) && exec fish
      fi
    '';
  };
}
