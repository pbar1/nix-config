{ lib, ... }:
let
  themes = [
    "base16-gruvbox-material-dark-soft"
    "base16-gruvbox-material-light-soft"
  ];
in
{
  programs.opencode.enable = true;
  programs.opencode.themes = lib.genAttrs themes (name: lib.importJSON ./themes/${name}.json);

  programs.opencode.settings = {
    theme = "system"; # Matches terminal theme
  };
}
