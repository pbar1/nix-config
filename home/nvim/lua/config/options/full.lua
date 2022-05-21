-- 24-bit RGB color in TUI - uses "gui" highlights instead of "cterm"
vim.opt.termguicolors = true

-- Set font to be used in GUIs (Neovide, etc)
vim.opt.guifont = "Iosevka_Nerd_Font_Mono"

-- Mouse support in all modes
vim.opt.mouse = "a"

-- Number of ms without typing before swap file is written to
vim.opt.updatetime = 100

-- Highlight the current line
vim.opt.cursorline = true

-- Show line numbers
vim.wo.number = true

-- Show sign column
vim.wo.signcolumn = "yes"

-- Show whitespace characters
vim.opt.list = true
vim.opt.listchars = {
	tab = "→ ",
	lead = "·",
	trail = "·",
	-- eol = "¬",
	extends = "»",
	precedes = "«",
	nbsp = "+",
}
