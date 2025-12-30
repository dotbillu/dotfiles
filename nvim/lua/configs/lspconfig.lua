-- lua/configs/lspconfig.lua

-- 1. Get default NvChad LSP options
local opts = require "nvchad.configs.lspconfig"

-- 2. Get the capabilities from nvim-cmp
local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

-- 3. Merge NvChad’s capabilities with nvim-cmp’s
opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, cmp_capabilities)

-- 4. List of language servers you have installed
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

-- 5. Loop through servers, register their configs and enable them
for _, server_name in ipairs(servers) do
  vim.lsp.config(server_name, opts)
  vim.lsp.enable(server_name)
end

