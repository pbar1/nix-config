{ pkgs, ... }:
let
  # TODO: https://www.reddit.com/r/Ghostty/comments/1hoi3id/my_perfect_ghostty_tmux_nvim_configuration_on/
  # M-Space keycode literal
  tmuxPrefix = ''text:\x1b\x20'';
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
      # iTerm2-like overlay for tmux
      "super+t=${tmuxPrefix}t"
      "super+w=${tmuxPrefix}x"
      "super+d=${tmuxPrefix}v"
      "shift+super+d=${tmuxPrefix}s"
      "super+f=${tmuxPrefix}/"
      "shift+super+enter=${tmuxPrefix}z"
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
