inputs:
[
  (final: prev: {
    # Neovim plugins auto-populated from flake inputs with `nvim:` hasPrefix
    myNvimPlugins =
      with final.lib;
      with attrsets;
      with strings;
      mapAttrs' (
        name: value:
        nameValuePair (removePrefix "nvim:" name) (
          final.vimUtils.buildVimPlugin {
            pname = removePrefix "nvim:" name;
            src = value.outPath;
            version = value.rev;
          }
        )
      ) (filterAttrs (name: _: hasPrefix "nvim:" name) inputs);

    nvim-pbar = final.callPackage ./pkgs/nvim {
      nixvim = inputs.nixvim.legacyPackages.${final.stdenv.hostPlatform.system};
    };
  })
]
++ [
  inputs.nix-vscode-extensions.overlays.default
]
