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
  # Readline shortcuts
  (kmap [ "i" "c" "n" "v" ] "<C-a>" "<Home>" "Go to start of line")
  (kmap [ "i" "c" "n" "v" ] "<C-e>" "<End>" "Go to end of line")
  (kmap [ "i" "c" "n" "v" ] "<M-b>" "<S-Left>" "Go back one word")
  (kmap [ "i" "c" "n" "v" ] "<M-f>" "<S-Right>" "Go forward one word")
  (kmap "i" "<C-_>" "<C-o>u" "Undo")
  (kmap "n" "<C-_>" "u" "Undo")
  (kmap "i" "<M-#>" "<C-o>gcc" "Toggle line comment" // remap)
  (kmap "n" "<M-#>" "gcc" "Toggle line comment" // remap)
  (kmap "v" "<M-#>" "gc" "Toggle line comment" // remap)

  # macOS shortcuts
  (kmap "i" "<F13>" "<C-o><Cmd>update<CR>" "Save file")
  (kmap "n" "<F13>" "<Cmd>update<CR>" "Save file")

  # Leader shortcuts
  (kmap "n" "<Leader><Leader>" ":" "Command mode")
  (kmap "n" "<Leader>db" "<Cmd>bdelete<CR>" "Close buffer")
  (kmap "n" "<Leader>dh" "<Cmd>nohlsearch<CR>" "Clear search highlight")
  (kmap "n" "<Leader>dw" "<Cmd>close<CR>" "Close window")
  (kmap "n" "<Leader>fb" "<Cmd>Telescope buffers<CR>" "Find buffers")
  (kmap "n" "<Leader>ff" "<Cmd>Telescope find_files<CR>" "Find files")
  (kmap "n" "<Leader>fg" "<Cmd>Telescope live_grep<CR>" "Find text")
  (kmap "n" "<Leader>fh" "<Cmd>Telescope help_tags<CR>" "Find help")
  (kmap "n" "<Leader>fm" "<Cmd>Telescope marks<CR>" "Find marks")
  (kmap "n" "<Leader>rn" (lua "vim.lsp.buf.rename") "Rename symbol")
  (kmap "n" "<Leader>td" "<Cmd>Trouble diagnostics toggle<CR>" "Toggle diagnostics")
]
