-- lua/configs/lspconfig.lua

local lspconfig = require "lspconfig"

-- 1. Get the default NvChad LSP options (CORRECTED LINE)
local opts = require "nvchad.configs.lspconfig"

-- 2. Get the capabilities from nvim-cmp
local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

-- 3. Merge NvChad's capabilities with nvim-cmp's
opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, cmp_capabilities)

-- 4. List all the language servers you have installed
local servers = {
  "clangd",
  "ts_ls",
  "tailwindcss",
  "eslint",
  "html",
  "cssls",
  "jsonls",
  "rust_analyzer",
}

-- 5. Loop through the servers and set them up with the merged options
for _, server_name in ipairs(servers) do
  lspconfig[server_name].setup(opts)
end
