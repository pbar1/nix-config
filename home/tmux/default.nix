{ config, pkgs, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.home) homeDirectory;

  repo = "${homeDirectory}/code/nix-config";
  tmuxConfig =
    if pkgs.stdenv.hostPlatform.isDarwin then
      mkOutOfStoreSymlink "${repo}/home/tmux/tmux.conf"
    else
      ./tmux.conf;
in
{
  home.packages = [ pkgs.tmux ];

  xdg.configFile."tmux/tmux.conf".source = tmuxConfig;
}
