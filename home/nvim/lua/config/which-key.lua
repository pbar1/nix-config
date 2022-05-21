local which_key = require("which-key")

which_key.setup({
	key_labels = {
		["<Leader>"] = "LDR",
		["<Space>"] = "SPC",
		["<CR>"] = "RET",
		["<Tab>"] = "TAB",
		["<Esc>"] = "ESC",
	},
})

local leader_mappings = {
	["f"] = {
		name = "+Telescope 🔭",
		["b"] = { "<cmd>Telescope buffers<cr>", "Buffers" },
		["f"] = { "<cmd>Telescope find_files<cr>", "Find files" },
		["g"] = { "<cmd>Telescope live_grep<cr>", "Live grep" },
		["h"] = { "<cmd>Telescope help_tags<cr>", "Help tags" },
		["r"] = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
	},
	["t"] = {
		name = "+Trouble 😈",
		["r"] = { "<cmd>TroubleRefresh<cr>", "Refresh Trouble" },
		["t"] = { "<cmd>TroubleToggle<cr>", "Toggle Trouble" },
	},
}
which_key.register(leader_mappings, { prefix = "<Leader>" })
