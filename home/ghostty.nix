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
      # macOS bindings for readline
      # Only those which are not sent automatically are set explicitly here
      ''opt+backspace=text:\x17'' # (ctrl-w) Delete word backwards
      ''cmd+z=text:\x1f'' # (ctrl-_) Undo
      ''cmd+/=text:\x1b#'' # (alt-#) Comment line

      # macOS bindings for tmux
      "cmd+digit_1=${tmuxPrefix}1"
      "cmd+digit_2=${tmuxPrefix}2"
      "cmd+digit_3=${tmuxPrefix}3"
      "cmd+digit_4=${tmuxPrefix}4"
      "cmd+digit_5=${tmuxPrefix}5"
      "cmd+digit_6=${tmuxPrefix}6"
      "cmd+digit_7=${tmuxPrefix}7"
      "cmd+digit_8=${tmuxPrefix}8"
      "cmd+digit_9=${tmuxPrefix}9"
      "cmd+t=${tmuxPrefix}c"
      "cmd+w=${tmuxPrefix}x"
      "cmd+d=${tmuxPrefix}%"
      ''shift+cmd+d=${tmuxPrefix}"''
      "shift+cmd+enter=${tmuxPrefix}z"
      "cmd+f=${tmuxPrefix}/" # (custom) Search backward

      # Fallback macOS shortcuts for Ghostty
      "opt+cmd+digit_1=goto_tab:1"
      "opt+cmd+digit_2=goto_tab:2"
      "opt+cmd+digit_3=goto_tab:3"
      "opt+cmd+digit_4=goto_tab:4"
      "opt+cmd+digit_5=goto_tab:5"
      "opt+cmd+digit_6=goto_tab:6"
      "opt+cmd+digit_7=goto_tab:7"
      "opt+cmd+digit_8=goto_tab:8"
      "opt+cmd+digit_9=goto_tab:9"
      "opt+cmd+t=new_tab"
      "opt+cmd+w=close_surface"
      "opt+cmd+d=new_split:right" # TODO: Conflicts with Dock
      "opt+shift+cmd+d=new_split:down"
      "opt+shift+cmd+enter=toggle_split_zoom"
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
