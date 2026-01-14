{ pkgs, ... }:

# TODO: https://github.com/zhaofengli/nix-homebrew
{
  environment.systemPackages = with pkgs; [
    wireshark
    wezterm
  ];

  homebrew.enable = true;

  # prefer "zap", but this may make docker/tailscale/wireshark flap
  homebrew.onActivation.cleanup = "none";

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
      "hammerspoon"
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
      "google-earth-pro"
      "keka"
      "kekaexternalhelper"
      "lulu"
      "netspot"
      "obsidian"
      "slack"
      "spotify"
      "sweet-home3d"
      "syntax-highlight"
      "tailscale-app"
      "visual-studio-code"
      "vlc"
      "zoom"
      "ghostty"
    ];
}
