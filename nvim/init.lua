vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.fn.expand "~/.config/kitty/kitty.conf",
  callback = function()
    vim.fn.system "kill -SIGUSR1 $(pidof kitty)"
  end,
})

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end
vim.opt.clipboard = "unnamedplus"
vim.opt.rtp:prepend(lazypath)
vim.opt.lazyredraw = true
local lazy_config = require "configs.lazy"
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "*",
--   callback = function()
--     vim.opt_local.foldmethod = "marker"
--     vim.opt_local.foldmarker = "{{{,}}}"
--   end,
-- })

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)
