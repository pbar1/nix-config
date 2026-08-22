{ ... }:

{
  # TODO: https://github.com/zhaofengli/nix-homebrew
  homebrew.enable = true;
  homebrew.onActivation.cleanup = "zap";

  homebrew.taps = [
    "cormacrelf/tap"
    {
      name = "docker/tap";
      trusted = true;
    }
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
    "codex"
    "cyberduck"
    "discord"
    "docker-desktop"
    "docker/tap/sbx"
    "font-iosevka-nerd-font"
    "font-monaspace-nf"
    "ghostty"
    "google-earth-pro"
    "iterm2"
    "karabiner-elements" # Required for Kanata
    "keepassxc"
    "keka"
    "lulu"
    "monitorcontrol"
    "obsidian"
    "raycast"
    "secretive"
    "slack"
    "spotify"
    "tailscale-app"
    "thaw"
    "visual-studio-code"
    "vlc"
    "vscodium"
    "whatsapp"
    "wireshark-app"
    "zoom"
  ];
}
