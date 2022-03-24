{
  description = "Configuration for NixOS, macOS, and Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:pbar1/nix-darwin"; # FIXME: Waiting for https://github.com/LnL7/nix-darwin/pull/310
    home-manager.url = "github:nix-community/home-manager";

    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "pierce";
      homeDirectory = "/home/pierce";
    in
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        modules = [ ./nixos ];
        system = "x86_64-linux";
      };

      darwinConfigurations.default = darwin.lib.darwinSystem {
        modules = [ ./darwin ];
        system = "x86_64-darwin";
      };

      homeConfigurations.bobbery = home-manager.lib.homeManagerConfiguration {
        configuration = import ./home;
        stateVersion = "22.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
        system = "x86_64-linux";
        username = "pierce";
        homeDirectory = "/home/pierce";
      };

      homeConfigurations.pbartine-ltm = home-manager.lib.homeManagerConfiguration {
        configuration = import ./home;
        stateVersion = "22.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
        system = "x86_64-darwin";
        username = "pbartine";
        homeDirectory = "/Users/pbartine";
      };
    };
}
