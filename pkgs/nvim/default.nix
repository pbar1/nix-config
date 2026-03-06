{ nixvim, pkgs }:
nixvim.makeNixvimWithModule {
  inherit pkgs;
  module = import ./config.nix { inherit pkgs; };
}
