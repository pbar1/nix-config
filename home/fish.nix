{ pkgs, ... }:

let
  shellAliases = import ./shell/aliases.nix { inherit pkgs; };
  shellAbbrs = import ./shell/abbrs.nix;
in
{
  programs.fish = {
    enable = true;

    inherit shellAbbrs;
    inherit shellAliases;

    # Flake inputs with the prefix `fish:` automatically end up here via overlay
    plugins =
      with pkgs.fishPlugins;
      [
        { inherit (fzf-fish) name src; }
        { inherit (autopair) name src; }
      ]
      ++ pkgs.lib.attrsets.mapAttrsToList (name: value: {
        inherit name;
        inherit (value) src;
      }) pkgs.myFishPlugins;

    interactiveShellInit = ''
      set fish_greeting
    '';

    functions = {
      starship_transient_prompt_func = "starship module character";
      starship_transient_rprompt_func = "starship module time";
    };
  };
}
