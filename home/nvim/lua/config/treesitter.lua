local treesitter = require("nvim-treesitter.configs")
local parsers = require("nvim-treesitter.parsers")

treesitter.setup({
	highlight = { enable = not vim.g.vscode },
	indent = { enable = false },
	rainbow = { enable = false },
})

parsers.filetype_to_parsername.tf = "hcl"
