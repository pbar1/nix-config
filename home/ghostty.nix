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
    gruvbox-material-dark-soft =
      let
        fg0 = "#d4be98";
        fg1 = "#ddc7a1";
        bg0 = "#32302f";
        bg4 = "#504945";
        bg_current_word = "#45403d";
        red = "#ea6962";
        green = "#a9b665";
        yellow = "#d8a657";
        blue = "#7daea3";
        purple = "#d3869b";
        aqua = "#89b482";
        orange = "#e78a4e";
      in
      {
        background = bg0;
        selection-background = bg_current_word;
        foreground = fg0;
        selection-foreground = fg0;
        cursor-color = orange;
        palette = [
          "0=${bg0}"
          "1=${red}"
          "2=${green}"
          "3=${yellow}"
          "4=${blue}"
          "5=${purple}"
          "6=${aqua}"
          "7=${fg0}"
          "8=${bg4}"
          "9=${red}"
          "10=${green}"
          "11=${yellow}"
          "12=${blue}"
          "13=${purple}"
          "14=${aqua}"
          "15=${fg1}"
        ];
      };
    gruvbox-material-light-soft =
      let
        fg0 = "#654735";
        fg1 = "#4f3829";
        bg0 = "#f2e5bc";
        bg4 = "#dac9a5";
        bg_current_word = "#ebdbb2";
        red = "#c14a4a";
        green = "#6c782e";
        yellow = "#b47109";
        blue = "#45707a";
        purple = "#945e80";
        aqua = "#4c7a5d";
        orange = "#c35e0a";
      in
      {
        background = bg0;
        selection-background = bg_current_word;
        foreground = fg0;
        selection-foreground = fg0;
        cursor-color = orange;
        palette = [
          "0=${bg0}"
          "1=${red}"
          "2=${green}"
          "3=${yellow}"
          "4=${blue}"
          "5=${purple}"
          "6=${aqua}"
          "7=${fg0}"
          "8=${bg4}"
          "9=${red}"
          "10=${green}"
          "11=${yellow}"
          "12=${blue}"
          "13=${purple}"
          "14=${aqua}"
          "15=${fg1}"
        ];
      };
  };
}
