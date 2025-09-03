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
  -- DEBUGGING (DAP)
  ------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    dependencies = { "rcarriga/nvim-dap-ui", "jay-babu/mason-nvim-dap.nvim" },
    config = function()
      local dap, dapui = require "dap", require "dapui"
      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "cppdbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.javascript = {
        {
          name = "Launch file",
          type = "pwa-node",
          request = "launch",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
        },
      }
      dap.configurations.typescript = dap.configurations.javascript
      dap.configurations.typescriptreact = dap.configurations.javascript
      dap.configurations.javascriptreact = dap.configurations.javascript
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason-nvim-dap.nvim", "mfussenegger/nvim-dap" },
    config = function()
      require("mason-nvim-dap").setup {
        ensure_installed = { "codelldb", "cpptools", "js-debug-adapter" },
        handlers = {},
      }
    end,
  },

  ------------------------------------------------------------------
  -- UI & EDITOR ENHANCEMENTS
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
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascriptreact", "typescriptreact", "vue" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
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

  ------------------------------------------------------------------
  -- LANGUAGE SPECIFIC PLUGINS
  ------------------------------------------------------------------
  { "mrcjkb/rustaceanvim", version = "^5", ft = { "rust" } },
  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function()
      require("crates").setup()
    end,
  },
}
