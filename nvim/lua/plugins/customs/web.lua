return {
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascriptreact", "typescriptreact", "vue" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "barrett-ruth/live-server.nvim",
    build = "npm install -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = true,
  },
}
