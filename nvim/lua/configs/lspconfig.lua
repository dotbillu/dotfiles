local opts = require "nvchad.configs.lspconfig"

local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, cmp_capabilities)

local servers = {
  "clangd",
  "eslint",
  "jsonls",
  "vtsls",
  "tailwindcss",
  "pyright",
}

for _, server_name in ipairs(servers) do
  vim.lsp.config(server_name, opts)
  vim.lsp.enable(server_name)
end

local lua_ls_opts = vim.tbl_deep_extend("force", opts, {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "hl" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
    },
  },
})

vim.lsp.config("lua_ls", lua_ls_opts)
vim.lsp.enable "lua_ls"

local qmlls_opts = vim.tbl_deep_extend("force", opts, {
  cmd = { "qmlls6" },
  filetypes = { "qml", "qmljs" },
  root_markers = { "qmldir", ".git" },
})

vim.lsp.config("qmlls", qmlls_opts)
vim.lsp.enable "qmlls"
