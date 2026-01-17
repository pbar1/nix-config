{ pkgs, ... }:
let
  tmuxPrefix = ''text:\x02''; # C-b
in
{
  programs.ghostty.enable = true;
  programs.ghostty.enableBashIntegration = true;
  programs.ghostty.enableZshIntegration = true;
  programs.ghostty.enableFishIntegration = true;

  # Install with Homebrew on macOS via nix-darwin
  programs.ghostty.package = if pkgs.stdenv.isDarwin then null else pkgs.ghostty;

  programs.ghostty.settings = {
    command = "${pkgs.tmux}/bin/tmux new-session -A -s main";
    confirm-close-surface = false;
    font-family = "Iosevka Nerd Font Mono";
    font-size = 16;
    macos-option-as-alt = true;
    maximize = true;
    quit-after-last-window-closed = true;
    theme = "light:gruvbox-material-light-soft,dark:gruvbox-material-dark-soft";
    window-padding-x = "9, 9";
    keybind = [
      # macOS shortcuts for tmux
      "super+digit_1=${tmuxPrefix}1"
      "super+digit_2=${tmuxPrefix}2"
      "super+digit_3=${tmuxPrefix}3"
      "super+digit_4=${tmuxPrefix}4"
      "super+digit_5=${tmuxPrefix}5"
      "super+digit_6=${tmuxPrefix}6"
      "super+digit_7=${tmuxPrefix}7"
      "super+digit_8=${tmuxPrefix}8"
      "super+digit_9=${tmuxPrefix}9"
      "super+t=${tmuxPrefix}c"
      "super+w=${tmuxPrefix}x"
      "super+d=${tmuxPrefix}%"
      ''shift+super+d=${tmuxPrefix}"''
      "shift+super+enter=${tmuxPrefix}z"
      "super+f=${tmuxPrefix}/" # (custom) Search backward

      # Fallback macOS shortcuts for Ghostty
      "alt+super+digit_1=goto_tab:1"
      "alt+super+digit_2=goto_tab:2"
      "alt+super+digit_3=goto_tab:3"
      "alt+super+digit_4=goto_tab:4"
      "alt+super+digit_5=goto_tab:5"
      "alt+super+digit_6=goto_tab:6"
      "alt+super+digit_7=goto_tab:7"
      "alt+super+digit_8=goto_tab:8"
      "alt+super+digit_9=goto_tab:9"
      "alt+super+t=new_tab"
      "alt+super+w=close_surface"
      "alt+super+d=new_split:right" # TODO: Conflicts with Dock
      "alt+shift+super+d=new_split:down"
      "alt+shift+super+enter=toggle_split_zoom"
    ];
  };

  programs.ghostty.themes = {
    gruvbox-material-light-soft = {
      background = "#f2e5bc";
      foreground = "#654735";
      cursor-color = "#654735";
      selection-background = "#ebdbb2";
      selection-foreground = "#654735";
      palette = [
        "0=#ebdbb2"
        "1=#c14a4a"
        "2=#6c782e"
        "3=#b47109"
        "4=#45707a"
        "5=#945e80"
        "6=#4c7a5d"
        "7=#654735"
        "8=#f3eac7"
        "9=#c14a4a"
        "10=#6c782e"
        "11=#b47109"
        "12=#45707a"
        "13=#945e80"
        "14=#4c7a5d"
        "15=#654735"
      ];
    };
    gruvbox-material-dark-soft = {
      background = "#32302f";
      foreground = "#d4be98";
      cursor-color = "#d4be98";
      selection-background = "#45403d";
      selection-foreground = "#d4be98";
      palette = [
        "0=252423"
        "1=#ea6962"
        "2=#a9b665"
        "3=#d8a657"
        "4=#7daea3"
        "5=#d3869b"
        "6=#89b482"
        "7=#d4be98"
        "8=#32302f"
        "9=#ea6962"
        "10=#a9b665"
        "11=#d8a657"
        "12=#7daea3"
        "13=#d3869b"
        "14=#89b482"
        "15=#d4be98"
      ];
    };
  };
}
