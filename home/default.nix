{ overlays, ... }:

{
  imports = [
    ./alacritty.nix
    ./env.nix
    ./fish.nix
    ./git.nix
    ./nvim
    ./packages.nix
    ./starship.nix
    ./tmux.nix
    ./wezterm
  ];

  nixpkgs = {
    inherit overlays;
    config.allowUnfree = true;

    # TODO: https://github.com/nix-community/home-manager/issues/2942
    config.allowUnfreePredicate = (pkg: true);
  };

  programs.home-manager.enable = true;
  programs.zoxide.enable = true;
  programs.bat = {
    enable = true;
    config = {
      style = "plain";
      theme = "base16-256";
    };
  };

  home.file.".gnupg/sshcontrol".text = ''
    # personal
    CDCD1DF93F65BF132EB1F33327E34108F53BD47A
    # work
    98A14E84BFC1A99FDE258E54659F86F577798596
  '';
}
