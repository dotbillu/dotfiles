local M = {}

M.base46 = {
  theme = "catppuccin",
  hl_override = {
    NvimTreeFileDirty = { link = "NvimTreeNormal" },
    NvimTreeFileNew = { link = "NvimTreeNormal" },
    NvimTreeGitDirty = { fg = "#B4E7DF" }, 
    NvimTreeGitNew = { fg = "#bb9af7" },
    NvimTreeGitStaged = { fg = "#FFFFFF" }, 
    NvimTreeGitDeleted = { fg = "#f7768e" },
  },
}

M.ui = {
  tabufline = { lazyload = false },
}

return M

