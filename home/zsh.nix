{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.zsh.enable = true;
  programs.zsh.dotDir = "${config.xdg.configHome}/zsh";
  programs.zsh.enableVteIntegration = true;
  programs.zsh.autosuggestion.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.shellAliases = import ./shell/aliases.nix { inherit pkgs; };
  programs.zsh.zsh-abbr.enable = false; # Saw errors causing long shell startup
  programs.zsh.zsh-abbr.abbreviations = import ./shell/abbrs.nix;

  programs.zsh.plugins = [
    {
      name = "zsh-autopair";
      src = pkgs.zsh-autopair;
    }
  ];

  programs.zsh.loginExtra = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin ''
    # Non-POSIX-compliant shells (for example, fish) should not be set as user
    # login shell. Exec said shell here as a workaround if desired.
    if [[ $(ps -p $PPID -o comm=) != "fish" && -z $ZSH_EXECUTION_STRING ]]; then
        (( $+commands[fish] )) && exec fish
    fi
  '';
}
