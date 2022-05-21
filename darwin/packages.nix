{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pinentry_mac
  ];

  homebrew = {
    enable = true;
    brewPrefix = "/Users/pbar/.brew/bin"; # FIXME: hardcode
    cleanup = "zap";
    autoUpdate = true;
    global.brewfile = true;
    global.noLock = true;

    taps = [
      "homebrew/cask"
      "homebrew/core"
      "homebrew/cask-drivers"
    ];

    # brews = [];

    casks = [
      "amethyst" # Automatic tiling window manager
      "clipy" # Clipboard history log
      "hiddenbar" # Menu bar app to hide icons in overflow menu
      "iterm2" # Terminal emulator
      "keepingyouawake" # Menu bar app to keep screen awake
      "qlmarkdown" # Quick Look plugin for Markdown rendering
      "rectangle" # Window snapping
      "syntax-highlight" # Quick Look plugin for syntax highlighting
      "wezterm" # Terminal emulator
    ];

    # masApps = {};
  };
}
