{ config, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;

  repo = "${homeDirectory}/code/nix-config";
in
{
  home.packages = [ pkgs.tmux ];

  xdg.configFile."tmux/tmux.conf".source = mkOutOfStoreSymlink "${repo}/home/tmux/tmux.conf";
}
