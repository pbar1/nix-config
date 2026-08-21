{ pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  # Helper snippet to configure nixd LSP
  flake = "(builtins.getFlake (builtins.toString ./.))";
in
{
  enableMan = false;

  extraPlugins = with pkgs; [
    myNvimPlugins.dark-notify
  ];

  # Settings ----------------------------------------------------------------

  globals = {
    mapleader = " ";
  };

  opts = {
    cursorline = true;
    expandtab = true;
    number = true;
    shiftwidth = 4;
    signcolumn = "yes";
    smartindent = true;
    softtabstop = 4;
    tabstop = 4;
    undofile = true;
  };

  clipboard.register = "unnamedplus"; # Copy to system clipboard
  colorschemes.base16.enable = true;
  editorconfig.enable = true;

  # React to system theme changes automatically. Putting it here avoids the
  # flash of unstyled color at startup. No need to set an explicit
  # colorscheme outside of this.
  extraConfigLuaPre = ''
    require('dark_notify').run({
      schemes = {
        dark = {
          colorscheme = "base16-gruvbox-material-dark-hard",
        },
        light = {
          colorscheme = "base16-gruvbox-material-light-soft",
        }
      }
    })
  '';

  keymaps = import ./keymaps.nix;

  # Plugins -----------------------------------------------------------------

  # General
  plugins.web-devicons.enable = true; # Required for Telescope and WhichKey
  plugins.telescope.enable = true;
  plugins.which-key.enable = true;
  plugins.mini.enable = true;
  plugins.mini.modules = {
    pairs = { };
    sessions = { };
    starter = { };
    tabline = { };
  };
  plugins.gitsigns.enable = true;
  plugins.trouble.enable = true;

  # Syntax
  plugins.treesitter.enable = true;
  plugins.treesitter.settings.highlight.enable = true;
  plugins.lsp.enable = true;
  plugins.lsp.servers.nixd.enable = true;
  plugins.lsp.servers.nixd.settings = {
    options.nix-darwin.expr = "${flake}.darwinConfigurations.bobbery.options";
    options.home-manager.expr = "${flake}.darwinConfigurations.bobbery.options.home-manager.users.type.getSubOptions []";
    options.nixvim.expr = ''${flake}.inputs.nixvim.nixvimConfigurations."${system}".default.options'';
  };
  plugins.lsp.servers.pyright.enable = true;
  plugins.lsp.servers.ts_ls.enable = true;
  plugins.rustaceanvim.enable = true;
  plugins.roslyn.enable = true;

  # Formatting
  plugins.conform-nvim.enable = true;
  plugins.conform-nvim.settings.format_on_save = {
    timeout_ms = 500;
    lsp_format = "fallback";
  };
  plugins.conform-nvim.settings.formatters_by_ft = {
    "*" = [
      "injected" # Formats code blocks
    ];
    javascript = [ "prettier" ];
    javascriptreact = [ "prettier" ];
    json = [ "prettier" ];
    nix = [ "nixfmt" ];
    python = [
      "isort"
      "black"
    ];
    rust = [ "rustfmt" ];
    sh = [ "shfmt" ];
    typescript = [ "prettier" ];
    typescriptreact = [ "prettier" ];
    yaml = [ "prettier" ];
  };

  # Completion
  plugins.colorful-menu.enable = true;
  plugins.blink-cmp.enable = true;
  plugins.blink-cmp.settings.signature.enabled = true;
  plugins.blink-cmp.settings.keymap = {
    preset = "enter";
    "<Esc>" = [
      "hide"
      "fallback"
    ];
  };
  plugins.blink-cmp.settings.completion.list.selection.preselect = false;
  plugins.blink-cmp.settings.completion.menu.draw = {
    columns = [
      { __unkeyed = "kind_icon"; }
      {
        __unkeyed = "label";
        gap = 1;
      }
    ];
    components.label.text.__raw = ''
      function(ctx)
        return require("colorful-menu").blink_components_text(ctx)
      end
    '';
    components.label.highlight.__raw = ''
      function(ctx)
        return require("colorful-menu").blink_components_highlight(ctx)
      end
    '';
  };

  # Statusline
  plugins.lualine.enable = true;
  plugins.lualine.settings.options.component_separators = "|";
  plugins.lualine.settings.options.section_separators = "";
  plugins.lualine.settings.options.globalstatus = true;
  plugins.lualine.settings.sections.lualine_b = [
    {
      __unkeyed = "branch";
      icon = "";
    }
    "diff"
    "diagnostics"
  ];
  plugins.lualine.settings.sections.lualine_c = [
    "filename"
    {
      __unkeyed = "lsp_status";
      icon = "";
      symbols.spinner = [
        "⠋"
        "⠙"
        "⠹"
        "⠸"
        "⠼"
        "⠴"
        "⠦"
        "⠧"
        "⠇"
        "⠏"
      ];
      symbols.done = "✓";
      symbols.separator = " ";
      ignore_lsp = [ ];
    }
  ];
}
