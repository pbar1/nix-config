{
  description = "pbar's Nix config";

  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:nix-darwin/nix-darwin";

    # Modules and overlays
    home-manager.url = "github:nix-community/home-manager";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixvim.url = "github:nix-community/nixvim";

    # Follow nixpkgs to avoid multiple copies of it bloating the store
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    # Neovim plugins
    "nvim:dark-notify" = {
      url = "github:cormacrelf/dark-notify";
      flake = false;
    };
  };

  outputs =
    {
      systems,
      nixpkgs,
      darwin,
      ...
    }@inputs:
    let
      # Add custom packages to Nixpkgs
      overlays = import ./overlays.nix inputs;

      # Expose a flake output attribute for all supported systems
      eachSystem = nixpkgs.lib.genAttrs (import systems);

      # Instantiate Nixpkgs for a given system including our overlay packages
      pkgsFor = system: import nixpkgs { inherit system overlays; };
    in
    {

      formatter = eachSystem (system: (pkgsFor system).nixfmt-tree);

      packages = eachSystem (
        system:
        {
          nvim-pbar = (pkgsFor system).nvim-pbar;
        }
        // nixpkgs.lib.optionalAttrs (system == "aarch64-darwin") {
          sbx = import ./pkgs/sbx.nix {
            inherit inputs;
            pkgs = import nixpkgs {
              system = "aarch64-linux";
              inherit overlays;
              config.allowUnfree = true;
            };
          };
        }
      );

      # Apply with: `task mac`
      darwinConfigurations."bobbery" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs.inputs = inputs;
        modules = [
          inputs.home-manager.darwinModules.home-manager
          ./darwin
          {
            nixpkgs.overlays = overlays;
            system.stateVersion = 4;
            system.primaryUser = "pierce";
            networking.hostName = "bobbery";
            networking.computerName = "Bobbery";
            home-manager.extraSpecialArgs.inputs = inputs;
            home-manager.users."pierce".home.stateVersion = "22.05";
          }
        ];
      };

      # Apply with: `task tec`
      nixosConfigurations."tec" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          inputs.home-manager.nixosModules.home-manager
          ./nixos-tec
          {
            nixpkgs.overlays = overlays;
          }
        ];
      };

      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          inputs.nixos-wsl.nixosModules.default
          {
            system.stateVersion = "24.05";
            wsl.enable = true;
            wsl.defaultUser = "nixos";
          }
        ];
      };

    };
}
