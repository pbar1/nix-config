{ pkgs, ... }:
let
  shellAliases = import ./shell/aliases.nix { inherit pkgs; };
  shellAbbrs = import ./shell/abbrs.nix;
in
{
  programs.fish.enable = true;
  programs.fish.shellAbbrs = shellAbbrs;
  programs.fish.shellAliases = shellAliases;

  programs.fish.plugins = with pkgs.fishPlugins; [
    { inherit (autopair) name src; }
    { inherit (bang-bang) name src; }
  ];

  programs.fish.interactiveShellInit = ''
    set fish_greeting
  '';
}
