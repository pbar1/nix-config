{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kanata
  ];

  # TODO: https://github.com/zhaofengli/nix-homebrew
  homebrew.enable = true;
  homebrew.onActivation.cleanup = "zap";

  homebrew.taps = [
    "cormacrelf/tap"
  ];

  homebrew.brews = [
    "cormacrelf/tap/dark-notify"
    "opencode"
    "openssl"
    "pkg-config"
    "pulumi"
  ];

  homebrew.casks = [
    "1password"
    "bettermouse"
    "brave-browser"
    "calibre"
    "codex"
    "cyberduck"
    "discord"
    "docker-desktop"
    "font-iosevka-nerd-font"
    "font-monaspace-nf"
    "ghostty"
    "google-earth-pro"
    "iterm2"
    "karabiner-elements" # Required for Kanata
    "keka"
    "kekaexternalhelper"
    "lulu"
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
