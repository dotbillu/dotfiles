local opts = require "nvchad.configs.lspconfig"

local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, cmp_capabilities)

local servers = {
  "clangd",
  "ts_ls",
  "tailwindcss",
  "eslint",
  "html",
  "cssls",
  "jsonls",
  "pyright",
}

for _, server_name in ipairs(servers) do
  vim.lsp.config(server_name, opts)
  vim.lsp.enable(server_name)
end

local qmlls_opts = vim.tbl_deep_extend("force", opts, {
  cmd = { "qmlls6" },
  filetypes = { "qml", "qmljs" },
  root_markers = { "qmldir", ".git" },
})

vim.lsp.config("qmlls", qmlls_opts)
vim.lsp.enable("qmlls")
