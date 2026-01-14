{ lib, ... }:

{
  imports = [
    ./env.nix
    ./fish.nix
    ./fzf.nix
    ./ghostty.nix
    ./git.nix
    ./gpg.nix
    ./hammerspoon
    ./nvim.nix
    ./packages.nix
    ./ssh.nix
    ./opencode
    ./starship.nix
    ./tmux.nix
    ./vscode.nix
    ./wezterm
    ./zsh.nix
  ];

  # Don't show Home Manager news on switch
  news.display = "silent";

  home.username = "pierce";
  home.homeDirectory = "/Users/pierce";
  home.stateVersion = "22.05";

  # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1119760100
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  programs.home-manager.enable = true;

  # Fish shell enables this for `man` completion to work, but it is very slow
  # https://github.com/NixOS/nixpkgs/issues/100288
  programs.man.generateCaches = lib.mkForce false;

  programs.zoxide.enable = true;

  # Theme set with environment variable BAT_THEME since Delta also uses it
  programs.bat.enable = true;
  programs.bat.config.style = "plain";
}
