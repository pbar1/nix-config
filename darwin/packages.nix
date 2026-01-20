{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vscodium
    wezterm
    wireshark
  ];

  # TODO: https://github.com/zhaofengli/nix-homebrew
  homebrew.enable = true;
  homebrew.onActivation.cleanup = "zap";

  homebrew.brews = [
    "openssl"
    "pkg-config"
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
      "brave-browser"
      "calibre"
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
      "whatsapp"
      "zoom"
    ];
}
