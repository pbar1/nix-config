let
  # Helper to create less verbose keymaps
  kmap = mode: key: action: desc: {
    inherit mode key action;
    options = { inherit desc; };
  };

  # Helper to send Lua in keymaps
  lua = __raw: { inherit __raw; };
in
[
  # Readline adapters - enables macOS text navigation shortcuts to work
  (kmap [ "i" "c" ] "<C-a>" "<Home>" "Go to start of line")
  (kmap [ "i" "c" ] "<C-e>" "<End>" "Go to end of line")
  (kmap [ "i" "c" ] "<M-b>" "<S-Left>" "Go back one word")
  (kmap [ "i" "c" ] "<M-f>" "<S-Right>" "Go forward one word")
  (kmap "i" "<C-_>" "<C-o>u" "Undo")
  (kmap "i" "<M-#>" "<C-o>gcc" "Toggle line comment" // { options.remap = true; })
  (kmap "n" "<M-#>" "gcc" "Toggle line comment" // { options.remap = true; })
  (kmap "v" "<M-#>" "gc" "Toggle line comment" // { options.remap = true; })

  # Leader shortcuts
  (kmap "n" "<leader><leader>" ":" "Open command line")
  (kmap "n" "<leader>ff" "<cmd>Telescope find_files<CR>" "Find files")
  (kmap "n" "<leader>fg" "<cmd>Telescope live_grep<CR>" "Live grep")
  (kmap "n" "<leader>fb" "<cmd>Telescope buffers<CR>" "Buffers")
  (kmap "n" "<leader>rn" (lua "vim.lsp.buf.rename") "Rename symbol")
]
