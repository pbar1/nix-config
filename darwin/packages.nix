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
    "chatgpt"
    "cyberduck"
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
    "slack"
    "sol"
    "spotify"
    "tailscale-app"
    "virtualbox"
    "visual-studio-code"
    "vlc"
    "whatsapp"
    "wireshark-app"
    "zoom"
  ];
}
