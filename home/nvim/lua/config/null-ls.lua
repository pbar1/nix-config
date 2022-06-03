local null_ls = require("null-ls")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
   sources = {
      null_ls.builtins.code_actions.statix,
      null_ls.builtins.completion.spell,
      null_ls.builtins.diagnostics.selene,
      null_ls.builtins.formatting.nixpkgs_fmt,
      null_ls.builtins.formatting.stylua,
   },

   on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
         vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
         vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
               vim.lsp.buf.format({
                  bufnr = bufnr,
                  filter = function(client)
                     return client.name == "null-ls"
                  end,
               })
            end,
         })
      end
   end,
})
