-- lua/plugins/customs/common.lua
-- Core tooling, editor enhancements (mason, lspconfig, conform, treesitter, cmp, autopairs, dressing, colorizer)

return {
  ------------------------------------------------------------------
  -- CORE TOOLING (Mason, LSP, Formatting)
  ------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "codelldb",
        "clangd",
        "clang-format",
        "cpptools",
        "typescript-language-server",
        "tailwindcss-language-server",
        "eslint-lsp",
        "css-lsp",
        "html-lsp",
        "json-lsp",
        "prettier",
        "js-debug-adapter",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        ["clang-format"] = {
          command = "clang-format",
          args = { "--style=file" },
          root_patterns = { ".clang-format", "compile_commands.json", ".git" },
        },
        ["prettier"] = {
          command = "prettier",
          args = { "--stdin-filepath", "$FILENAME" },
          root_patterns = { ".prettierrc", ".prettierrc.json", "package.json" },
        },
      },
      formatters_by_ft = require("configs.conform").formatters_by_ft,
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
  },

  ------------------------------------------------------------------
  -- TREESITTER
  ------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  ------------------------------------------------------------------
  -- COMPLETION & SNIPPETS
  ------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require "configs.cmp"
    end,
  },

  ------------------------------------------------------------------
  -- EDITOR ENHANCEMENTS
  ------------------------------------------------------------------
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufRead",
    opts = {
      user_default_options = {
        mode = "virtualtext",
      },
    },
  },
{
  "mg979/vim-visual-multi",
  branch = "master",
  event = "VeryLazy",
}
 }
