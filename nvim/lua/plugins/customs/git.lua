return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      current_line_blame = false,
      current_line_blame_opts = {
        delay = 200,
        virt_text_pos = "eol",
      },
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit" },
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
    event = "BufRead",
  },
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      -- view = {
      --   side = "right",
      -- },
      renderer = {
        icons = {
          show = {
            git = true,
          },
          glyphs = {
            git = {
              unstaged = "",
              staged = "",
              unmerged = "",
              renamed = "➜",
              untracked = "",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      vim.api.nvim_set_hl(0, "NvimTreeGitStaged", { fg = "#ffffff" })
    end,
  },
}
