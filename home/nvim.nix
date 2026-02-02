{ config, pkgs, ... }:
let
  helpers = config.lib.nixvim;
in
{
  # Previous Neovim config
  # https://github.com/pbar1/dotfiles/tree/c2ca9ff3138ad68f010ff81581a5d2f88f43cc7f/home/nvim
  programs.nixvim = {
    enable = true;

    extraPlugins = with pkgs.myNvimPlugins; [
      dark-notify
    ];

    # React to system theme changes automatically. Putting it here avoids the
    # flash of unstyled color at startup.
    extraConfigLuaPre = ''
      require('dark_notify').run({
        schemes = {
          dark = {
            colorscheme = "base16-gruvbox-material-dark-soft",
          },
          light = {
            colorscheme = "base16-gruvbox-material-light-soft",
          }
        }
      })
    '';

    colorschemes.base16.enable = true;

    # Yank to system clipboard
    clipboard.register = "unnamedplus";

    # TODO: Map `cmd-z` to undo while in insert mode using a readline adapter
    globals.mapleader = " ";
    keymaps = [
      # Text editing and movement
      {
        mode = "i";
        key = "<C-a>";
        action = "<Home>";
        options.desc = "Go to start of line";
      }
      {
        mode = "i";
        key = "<C-e>";
        action = "<End>";
        options.desc = "Go to end of line";
      }
      {
        mode = "i";
        key = "<M-b>";
        action = "<C-o>b";
        options.desc = "Go back one word";
      }
      {
        mode = "i";
        key = "<M-f>";
        action = "<C-o>w";
        options.desc = "Go forward one word";
      }
      {
        # TODO: May need to map space/enter to `<C-g>u` to chunk up undos
        mode = "i";
        key = "<C-_>";
        action = "<C-o>u";
        options.desc = "Undo";
      }
      {
        mode = "n";
        key = "<M-#>";
        action = "gcc";
        options.desc = "Toggle line comment";
        options.remap = true;
      }
      {
        mode = "i";
        key = "<M-#>";
        action = "<C-o>gcc";
        options.desc = "Toggle line comment";
        options.remap = true;
      }
      {
        mode = "v";
        key = "<M-#>";
        action = "gc";
        options.desc = "Toggle comment on selection";
        options.remap = true;
      }
      # Search
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        options.desc = "Live grep";
      }
      # Quitting and saving
      {
        mode = "n";
        key = "<leader>qq";
        action = "<cmd>q!<cr>";
        options.desc = "Force quit without save";
      }
      {
        mode = "n";
        key = "<leader>qx";
        action = "<cmd>x<cr>";
        options.desc = "Save and quit";
      }
      {
        mode = "n";
        key = "<leader>s";
        action = "<cmd>w<cr>";
        options.desc = "Save";
      }
      # Window manipulation
      {
        mode = "n";
        key = "<leader>wc";
        action = "<cmd>close<cr>";
        options.desc = "Close window";
      }
      {
        mode = "n";
        key = "<leader>wh";
        action = "<cmd>split<cr>";
        options.desc = "Split horizontally";
      }
      {
        mode = "n";
        key = "<leader>wv";
        action = "<cmd>vsplit<cr>";
        options.desc = "Split vertically";
      }
      # LSP
      {
        mode = "n";
        key = "<leader>rn";
        action.__raw = "vim.lsp.buf.rename";
        options.desc = "Rename symbol";
      }
    ];

    editorconfig.enable = true;

    # Required for plugins like Telescope and Which-Key
    plugins.web-devicons.enable = true;

    plugins.mini.enable = true;
    plugins.mini.modules = {
      starter = { };
      sessions = { };
    };

    plugins.lualine.enable = true;
    plugins.lualine.settings.options.component_separators = "|";
    plugins.lualine.settings.options.section_separators = "";
    plugins.lualine.settings.options.globalstatus = true;
    plugins.lualine.settings.sections.lualine_b = [
      {
        __unkeyed = "branch";
        icon = "";
      }
      "diff"
      "diagnostics"
    ];
    plugins.lualine.settings.sections.lualine_c = [
      "filename"
      {
        __unkeyed = "lsp_status";
        icon = "";
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

    plugins.telescope.enable = true;

    plugins.which-key.enable = true;

    plugins.blink-cmp.enable = true;
    plugins.blink-cmp.settings.signature.enabled = true;
    plugins.blink-cmp.settings.keymap.preset = "enter";
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
    plugins.colorful-menu.enable = true;

    plugins.treesitter.enable = true;
    plugins.treesitter.settings.highlight.enable = true;

    plugins.lsp.enable = true;
    plugins.lsp.servers.nixd.enable = true;
    plugins.rustaceanvim.enable = true;

    plugins.conform-nvim.enable = true;
    plugins.conform-nvim.settings.format_on_save = {
      timeout_ms = 500;
      lsp_format = "fallback";
    };
    plugins.conform-nvim.settings.formatters_by_ft = {
      "*" = [ "injected" ]; # Formats code blocks
      nix = [ "nixfmt" ];
      rust = [ "rustfmt" ];
    };
  };
}
