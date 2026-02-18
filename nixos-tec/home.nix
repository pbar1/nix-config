{ ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.nixos = {
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.05";

    imports = [
      ../home-ng/env.nix
      ../home-ng/git.nix
      ../home-ng/shell.nix
    ];

    home.sessionVariables = {
      TORRENTS = "/data/torrents/qbittorrent/complete";
      MOVIES = "/data/media/movies";
      TV = "/data/media/tv";
      AUDIOBOOKS = "/data/media/audiobooks";
    };

    home.shellAliases = {
      to = "cd $TORRENTS";
      mo = "cd $MOVIES";
      tv = "cd $TV";
      ab = "cd $AUDIOBOOKS";
    };
  };
}
