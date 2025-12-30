-- lua/configs/conform.lua
local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    -- Web Dev Filetypes
    javascript = { "prettier" },
    javascriptreact = { "prettier" }, -- JSX
    typescript = { "prettier" },
    typescriptreact = { "prettier" }, -- TSX
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    --python
    python = { "isort", "black" },
  },
}
return options
