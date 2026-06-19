{ pkgs, ... }:
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
    "podman"
    "pulumi"
  ];

  homebrew.casks = [
    "1password"
    "bettermouse"
    "brave-browser"
    "calibre"
    "codex"
    "codex-app"
    "cyberduck"
    "discord"
    "font-iosevka-nerd-font"
    "font-monaspace-nf"
    "ghostty"
    "google-earth-pro"
    "iterm2"
    "karabiner-elements" # Required for Kanata
    "keka"
    "lulu"
    "monitorcontrol"
    "raycast"
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
