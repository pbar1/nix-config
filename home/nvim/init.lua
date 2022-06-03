require("config.options.core")
require("config.treesitter")

if not vim.g.vscode then
   require("config.options.full")
   require("config.auto-session")
   require("config.colorscheme")
   require("config.alpha")
   require("config.lualine")
   require("config.telescope")
   require("config.trouble")
   require("config.which-key")
   require("config.null-ls")
end
