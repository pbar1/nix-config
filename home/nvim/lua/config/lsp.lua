local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local null_ls = require("null-ls")

-- Enable LSP completion
local caps = vim.lsp.protocol.make_client_capabilities()
caps = cmp_nvim_lsp.update_capabilities(caps)

-- Disable LSP formatting in favor of null-ls
local on_attach = function(client)
   client.server_capabilities.document_formatting = false
   client.server_capabilities.document_range_formatting = false
end

-- LSP servers that need only minimal config
for _, lsp in pairs({ "bashls", "pyright", "rnix" }) do
   lspconfig[lsp].setup({ on_attach = on_attach, capabilities = caps })
end

-- LSP server for Lua with extra config for the Neovim Lua runtime
lspconfig.sumneko_lua.setup({
   on_attach = on_attach,
   capabilities = caps,
   settings = {
      Lua = {
         runtime = { version = "LuaJIT" },
         diagnostics = { globals = { "vim" } },
         workspace = { library = vim.api.nvim_get_runtime_file("", true) },
         telemetry = { enable = false },
      },
   },
})

-- LSP server for running external processes (formatters, diagnostics)
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
   sources = {
      null_ls.builtins.code_actions.statix,
      null_ls.builtins.completion.spell,
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
               vim.lsp.buf.format({ bufnr = bufnr })
            end,
         })
      end
   end,
})
