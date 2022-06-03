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
   require("config.completion")
   require("config.lsp")
   require("config.which-key")
end
