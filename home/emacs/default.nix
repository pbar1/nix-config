{ config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  nixConfig = "${config.home.homeDirectory}/code/nix-config";
in
{
  # Sets the icon for Emacs on macOS installed via Homebrew. Takes effect after
  # `brew reinstall --cask emacs-plus-app`.
  xdg.configFile."emacs-plus/build.yml".text = ''
    icon: liquid-glass
  '';

  # Symlink Emacs config to this repo for rapid iteration
  xdg.configFile."emacs/init.el".source = mkOutOfStoreSymlink "${nixConfig}/home/emacs/init.el";
}
