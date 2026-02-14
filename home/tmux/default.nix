{ config, pkgs, ... }:

{
  home.packages = [ pkgs.tmux ];

  xdg.configFile."tmux/tmux.conf".source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/code/nix-config/home/tmux/tmux.conf";
}
