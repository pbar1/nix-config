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
      "1password"
      "amethyst"
      "bartender"
      "clipy"
      "iterm2"
      "keepingyouawake"
      "qlmarkdown"
      "rectangle"
      "syntax-highlight"
      "wezterm"
    ];

    # masApps = {};
  };
}
