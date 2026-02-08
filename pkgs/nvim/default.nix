{ nixvim, pkgs }:
nixvim.makeNixvimWithModule {
  inherit pkgs;
  module = import ./module.nix { inherit pkgs; };
}
