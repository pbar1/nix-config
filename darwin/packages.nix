{ pkgs, ... }:

# TODO: https://github.com/zhaofengli/nix-homebrew
{
  environment.systemPackages = with pkgs; [
    wireshark
    wezterm
  ];

  homebrew.enable = true;

  # prefer "zap", but this may make docker/tailscale/wireshark flap
  homebrew.onActivation.cleanup = "zap";

  homebrew.taps = [
    "homebrew/services"
  ];

  homebrew.brews = [
    "openssl"
    "pkg-config"
  ];

  homebrew.casks =
    # Core
    [
      "1password"
      "amethyst"
      "bettermouse"
      "font-iosevka-nerd-font"
      "jordanbaird-ice"
      "keepingyouawake"
      "maccy"
    ]
    # Personal machine
    ++ [
      "brave-browser"
      "calibre"
      "cyberduck"
      "docker-desktop"
      "ghostty"
      "google-earth-pro"
      "keka"
      "kekaexternalhelper"
      "lulu"
      "slack"
      "spotify"
      "tailscale-app"
      "visual-studio-code"
      "vlc"
      "zoom"
    ];
}
