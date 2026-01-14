{
  description = "Configuration for NixOS, macOS, and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:nix-darwin/nix-darwin";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    home-manager.url = "github:nix-community/home-manager";
    nixvim.url = "github:nix-community/nixvim";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    # Fish Plugins ------------------------------------------------------------

    "fish:plugin-bang-bang" = {
      url = "github:oh-my-fish/plugin-bang-bang";
      flake = false;
    };

    # Hammerspoon Plugins -----------------------------------------------------

    "spoon:ReloadConfiguration" = {
      url = "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/ReloadConfiguration.spoon.zip";
      flake = false;
    };
    "spoon:Seal" = {
      url = "https://github.com/Hammerspoon/Spoons/raw/master/Spoons/Seal.spoon.zip";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      darwin,
      home-manager,
      nixos-wsl,
      nixvim,
      nix-vscode-extensions,
      ...
    }@inputs:
    let
      overlays = [
        (final: prev: {

          myFishPlugins =
            with final.lib;
            with attrsets;
            with strings;
            mapAttrs' (
              name: value:
              nameValuePair (removePrefix "fish:" name) (
                final.fishPlugins.buildFishPlugin {
                  pname = removePrefix "fish:" name;
                  src = value.outPath;
                  version = value.rev;
                }
              )
            ) (filterAttrs (name: _: hasPrefix "fish:" name) inputs);

          myHammerspoonPlugins =
            with final.lib;
            with attrsets;
            with strings;
            mapAttrs' (
              name: value:
              nameValuePair (removePrefix "spoon:" name) {
                name = removePrefix "spoon:" name;
                src = value.outPath;
              }
            ) (filterAttrs (name: _: hasPrefix "spoon:" name) inputs);

        }) # END final: prev:
      ]; # END overlays
    in
    {

      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        modules = [
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "24.05";
            wsl.enable = true;
            wsl.defaultUser = "nixos";
          }
        ];
        system = "x86_64-linux";
      };

      nixosConfigurations."tec" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (
            { config, pkgs, ... }:
            {
              nixpkgs.overlays = overlays;
            }
          )
          ./nixos-tec
          home-manager.nixosModules.home-manager
        ];
      };

      darwinConfigurations."bobbery" = darwin.lib.darwinSystem {
        modules = [
          (
            { config, pkgs, ... }:
            {
              nixpkgs.overlays = overlays ++ [ nix-vscode-extensions.overlays.default ];
            }
          )
          ./darwin
          home-manager.darwinModules.home-manager
          {
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
        specialArgs = { inherit inputs; };
        system = "aarch64-darwin";
      };

    }; # END outputs
} # END flake
