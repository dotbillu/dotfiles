local config_path = vim.fn.stdpath("config")
vim.opt.rtp:prepend(config_path .. "/catppuccin")

require("catppuccin").setup({
    flavour = "mocha", 
    transparent_background = false, 
    color_overrides = {
        mocha = {
            base = "#1e1e2e",
        },
    },
})

vim.opt.termguicolors = true

vim.cmd.colorscheme "catppuccin-mocha"
