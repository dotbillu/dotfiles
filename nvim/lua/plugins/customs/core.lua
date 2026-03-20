return {
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
        "pyright",
        "black",
        "isort",
        "debugpy",
        "python",
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
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    config = function()
      vim.o.foldcolumn = "0"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require("ufo").setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
      }
    end,
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
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    config = function()
      require("grug-far").setup {}
    end,
  },
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
  },
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "leafo/magick",
        build = "luarocks install --server=https://luarocks.org/dev magick",
      },
    },
    opts = {
      backend = "kitty",

      -- This is the list of files that will "hijack" the buffer to show the image
      -- instead of the binary garbage text.
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif", "*.svg", "*.ico" },
      integrations = {
        -- You requested these be disabled:
        markdown = {
          enabled = false,
        },
        neorg = {
          enabled = false,
        },
        html = {
          enabled = false,
        },
        css = {
          enabled = false,
        },
      },

      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = nil,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },
}
