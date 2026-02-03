{
  description = "Configuration for NixOS, macOS, and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:nix-darwin/nix-darwin";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    home-manager.url = "github:nix-community/home-manager";
    nixvim.url = "github:nix-community/nixvim";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # Follow nixpkgs to avoid multiple copies of it bloating the store
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    # Neovim plugins
    "nvim:dark-notify" = {
      url = "github:cormacrelf/dark-notify";
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

          nvim-pbar = final.callPackage ./packages/nvim-pbar {
            nixvim = nixvim.legacyPackages.${final.stdenv.hostPlatform.system};
          };

        }) # END final: prev:
      ]; # END overlays

      # Helper to generate packages for each system
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      pkgsFor = system: import nixpkgs { inherit system overlays; };
    in
    {

      packages = forAllSystems (system: {
        nvim-pbar = (pkgsFor system).nvim-pbar;
      });

      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "24.05";
            wsl.enable = true;
            wsl.defaultUser = "nixos";
          }
        ];
      };

      # `task tec`
      nixosConfigurations."tec" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          ./nixos-tec
          { nixpkgs.overlays = overlays; }
        ];
      };

      # `task mac`
      darwinConfigurations."bobbery" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs.inputs = inputs;
        modules = [
          home-manager.darwinModules.home-manager
          ./darwin
          {
            nixpkgs.overlays = overlays ++ [ nix-vscode-extensions.overlays.default ];
            system.stateVersion = 4;
            system.primaryUser = "pierce";
            networking.hostName = "bobbery";
            networking.computerName = "Bobbery";
            home-manager.users.pierce.home.stateVersion = "22.05";
            home-manager.extraSpecialArgs.inputs = inputs;
          }
        ];
      };

    }; # END outputs
} # END flake
