let
  kmap = mode: key: action: desc: {
    inherit mode key action;
    options = { inherit desc; };
  };

  lua = __raw: { inherit __raw; };

  remap = {
    options.remap = true;
  };
in
[
  # Readline adapters (also enables some macOS text shortcuts)
  (kmap [ "i" "c" "n" "v" ] "<C-a>" "<Home>" "Go to start of line")
  (kmap [ "i" "c" "n" "v" ] "<C-e>" "<End>" "Go to end of line")
  (kmap [ "i" "c" "n" "v" ] "<M-b>" "<S-Left>" "Go back one word")
  (kmap [ "i" "c" "n" "v" ] "<M-f>" "<S-Right>" "Go forward one word")
  (kmap "i" "<C-_>" "<C-o>u" "Undo")
  (kmap "n" "<C-_>" "u" "Undo")
  (kmap "i" "<M-#>" "<C-o>gcc" "Toggle line comment" // remap)
  (kmap "n" "<M-#>" "gcc" "Toggle line comment" // remap)
  (kmap "v" "<M-#>" "gc" "Toggle line comment" // remap)

  # Leader shortcuts
  (kmap "n" "<leader><leader>" ":" "Command mode")
  (kmap "n" "<leader>db" "<cmd>bdelete<CR>" "Close buffer")
  (kmap "n" "<leader>dh" "<cmd>nohlsearch<CR>" "Clear search highlight")
  (kmap "n" "<leader>dw" "<cmd>close<CR>" "Close window")
  (kmap "n" "<leader>fb" "<cmd>Telescope buffers<CR>" "Find buffers")
  (kmap "n" "<leader>ff" "<cmd>Telescope find_files<CR>" "Find files")
  (kmap "n" "<leader>fg" "<cmd>Telescope live_grep<CR>" "Find text")
  (kmap "n" "<leader>fh" "<cmd>Telescope help_tags<CR>" "Find help")
  (kmap "n" "<leader>fm" "<cmd>Telescope marks<CR>" "Find marks")
  (kmap "n" "<leader>rn" (lua "vim.lsp.buf.rename") "Rename symbol")
  (kmap "n" "<leader>td" "<cmd>Trouble diagnostics toggle<CR>" "Toggle diagnostics")
]
