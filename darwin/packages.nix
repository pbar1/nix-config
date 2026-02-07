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
    "openssl"
    "pkg-config"
    "pulumi"
  ];

  homebrew.casks =
    # Core
    [
      "1password"
      "bettermouse"
      "font-iosevka-nerd-font"
      "ghostty"
      "raycast"
      "thaw"
    ]
    # Personal machine
    ++ [
      "antigravity"
      "brave-browser"
      "calibre"
      "cursor"
      "cyberduck"
      "discord"
      "docker-desktop"
      "font-geist-mono-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "google-earth-pro"
      "iterm2"
      "karabiner-elements"
      "keka"
      "kekaexternalhelper"
      "lulu"
      "slack"
      "spotify"
      "tailscale-app"
      "visual-studio-code"
      "vlc"
      "vscodium"
      "whatsapp"
      "wireshark-app"
      "zoom"
    ];
}
