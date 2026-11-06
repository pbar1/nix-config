{ ... }:

{
  # TODO: https://github.com/zhaofengli/nix-homebrew
  homebrew.enable = true;
  homebrew.onActivation.cleanup = "zap";

  homebrew.taps = [
    "cormacrelf/tap"
  ];

  homebrew.brews = [
    "cormacrelf/tap/dark-notify"
    "kanata"
    "opencode"
    "openssl"
    "pkg-config"
  ];

  homebrew.casks = [
    "1password"
    "bettermouse"
    "brave-browser"
    "calibre"
    "discord"
    "font-iosevka-nerd-font"
    "font-monaspace-nf"
    "ghostty"
    "google-earth-pro"
    "karabiner-elements" # Required for Kanata
    "keepassxc"
    "keepingyouawake"
    "keka"
    "lulu"
    "monitorcontrol"
    "obsidian"
    "secretive"
    "sol"
    "spotify"
    "tailscale-app"
    "virtualbox"
    "visual-studio-code"
    "vlc"
    "wireshark-app"
    "zoom"
  ];
}
