{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ ];

  # TODO: https://github.com/zhaofengli/nix-homebrew
  homebrew.enable = true;
  homebrew.onActivation.cleanup = "zap";

  homebrew.brews = [
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
      "jordanbaird-ice"
      "keepingyouawake"
      "maccy"
      "raycast"
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
      "google-earth-pro"
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
