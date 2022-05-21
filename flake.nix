{
  description = "Configuration for NixOS, macOS, and Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # TODO: Await https://github.com/LnL7/nix-darwin/pull/310
    darwin.url = "github:pbar1/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Overlays ----------------------------------------------------------------

    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";

    # Neovim Plugins ----------------------------------------------------------

    "vim:alpha-nvim" = { url = "github:goolord/alpha-nvim"; flake = false; };
    "vim:barbar.nvim" = { url = "github:romgrk/barbar.nvim"; flake = false; };
    "vim:cmp-buffer" = { url = "github:hrsh7th/cmp-buffer"; flake = false; };
    "vim:cmp-cmdline" = { url = "github:hrsh7th/cmp-cmdline"; flake = false; };
    "vim:cmp-emoji" = { url = "github:hrsh7th/cmp-emoji"; flake = false; };
    "vim:cmp-nvim-lsp" = { url = "github:hrsh7th/cmp-nvim-lsp"; flake = false; };
    "vim:cmp-nvim-lsp-signature-help" = { url = "github:hrsh7th/cmp-nvim-lsp-signature-help"; flake = false; };
    "vim:cmp-nvim-lua" = { url = "github:hrsh7th/cmp-nvim-lua"; flake = false; };
    "vim:cmp-path" = { url = "github:hrsh7th/cmp-path"; flake = false; };
    "vim:cmp-treesitter" = { url = "github:ray-x/cmp-treesitter"; flake = false; };
    "vim:cmp-vsnip" = { url = "github:hrsh7th/cmp-vsnip"; flake = false; };
    "vim:editorconfig-vim" = { url = "github:editorconfig/editorconfig-vim"; flake = false; };
    "vim:filetype.nvim" = { url = "github:nathom/filetype.nvim"; flake = false; };
    "vim:gitsigns.nvim" = { url = "github:lewis6991/gitsigns.nvim"; flake = false; };
    "vim:gruvbox-material" = { url = "github:sainnhe/gruvbox-material"; flake = false; };
    "vim:lightspeed.nvim" = { url = "github:ggandor/lightspeed.nvim"; flake = false; };
    "vim:lsp_signature.nvim" = { url = "github:ray-x/lsp_signature.nvim"; flake = false; };
    "vim:lspkind.nvim" = { url = "github:onsails/lspkind.nvim"; flake = false; };
    "vim:lualine.nvim" = { url = "github:nvim-lualine/lualine.nvim"; flake = false; };
    "vim:null-ls.nvim" = { url = "github:jose-elias-alvarez/null-ls.nvim"; flake = false; };
    "vim:nvim-cmp" = { url = "github:hrsh7th/nvim-cmp"; flake = false; };
    "vim:nvim-colorizer.lua" = { url = "github:norcalli/nvim-colorizer.lua"; flake = false; };
    "vim:nvim-gps" = { url = "github:SmiteshP/nvim-gps"; flake = false; };
    "vim:nvim-lspconfig" = { url = "github:neovim/nvim-lspconfig"; flake = false; };
    "vim:nvim-notify" = { url = "github:rcarriga/nvim-notify"; flake = false; };
    "vim:nvim-tree.lua" = { url = "github:kyazdani42/nvim-tree.lua"; flake = false; };
    "vim:nvim-web-devicons" = { url = "github:kyazdani42/nvim-web-devicons"; flake = false; };
    "vim:plenary.nvim" = { url = "github:nvim-lua/plenary.nvim"; flake = false; };
    "vim:rust-tools.nvim" = { url = "github:simrat39/rust-tools.nvim"; flake = false; };
    "vim:spellsitter.nvim" = { url = "github:lewis6991/spellsitter.nvim"; flake = false; };
    "vim:telescope-fzf-native.nvim" = { url = "github:nvim-telescope/telescope-fzf-native.nvim"; flake = false; };
    "vim:telescope-ui-select.nvim" = { url = "github:nvim-telescope/telescope-ui-select.nvim"; flake = false; };
    "vim:telescope-zoxide" = { url = "github:jvgrootveld/telescope-zoxide"; flake = false; };
    "vim:telescope.nvim" = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
    "vim:trouble.nvim" = { url = "github:folke/trouble.nvim"; flake = false; };
    "vim:vim-lastplace" = { url = "github:farmergreg/vim-lastplace"; flake = false; };
    "vim:vim-numbertoggle" = { url = "github:jeffkreeftmeijer/vim-numbertoggle"; flake = false; };
    "vim:vim-startuptime" = { url = "github:dstein64/vim-startuptime"; flake = false; };
    "vim:vim-vsnip" = { url = "github:hrsh7th/vim-vsnip"; flake = false; };
    "vim:which-key.nvim" = { url = "github:folke/which-key.nvim"; flake = false; };
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs:
    let
      overlays = [
        inputs.fenix.overlay
        inputs.neovim-nightly-overlay.overlay
        inputs.emacs-overlay.overlay
        (final: prev: {
          neovimPlugins = with final.lib; with attrsets; with strings; mapAttrs'
            (name: value: nameValuePair (removePrefix "vim:" name) (final.vimUtils.buildVimPluginFrom2Nix {
              name = removePrefix "vim:" name;
              src = value.outPath;
              namePrefix = "";
              buildPhase = if hasInfix "fzf-native" name then "make" else ":";
            }))
            (filterAttrs (name: _: hasPrefix "vim:" name) inputs);
        })
      ];
    in
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        modules = [ ./nixos ];
        system = "x86_64-linux";
      };

      darwinConfigurations.default = darwin.lib.darwinSystem {
        modules = [ ./darwin ];
        system = "aarch64-darwin";
      };

      homeConfigurations.bobbery = home-manager.lib.homeManagerConfiguration {
        configuration = import ./home { inherit overlays; };
        stateVersion = "22.05";
        system = "x86_64-linux";
        username = "pierce";
        homeDirectory = "/home/pierce";
      };

      homeConfigurations.pbar-mbp = home-manager.lib.homeManagerConfiguration {
        configuration = import ./home { inherit overlays; };
        stateVersion = "22.05";
        system = "aarch64-darwin";
        username = "pbar";
        homeDirectory = "/Users/pbar";
      };
    };
}
