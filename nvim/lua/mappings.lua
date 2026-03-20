require "nvchad.mappings"
local map = vim.keymap.set

------------------------------------------------------------------
-- UI / General
------------------------------------------------------------------

map("n", ";", ":", { desc = "CMD: Enter command mode" })
map("i", "jk", "<ESC>", { desc = "KEYS: Escape insert mode" })

map("n", "t", "<cmd>NvimTreeToggle<CR>", { desc = "UI: Toggle file tree" })

map("n", "<leader>cl", "<cmd>Telescope keymaps<cr>", { desc = "UI: List keymaps" })

map("x", "p", [["_dP]], { desc = "Edit: Paste without copy" })
map("v", "x", [["_d]], { desc = "Edit: Delete without copy" })

map("n", "<leader>sr", "<cmd>GrugFar<CR>", { desc = "Search: Replace (GrugFar)" })

------------------------------------------------------------------
-- Folding (ufo)
------------------------------------------------------------------

local ufo = require "ufo"

map("n", "zR", function()
  ufo.openAllFolds()
end, { desc = "Fold: Open all" })

map("n", "zM", function()
  ufo.closeAllFolds()
end, { desc = "Fold: Close all" })

------------------------------------------------------------------
-- Terminal / Tools
------------------------------------------------------------------

map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Markdown: Preview" })
map("n", "<leader>hl", "<cmd>LiveServerToggle<CR>", { desc = "HTML: Live Server" })

------------------------------------------------------------------
-- Debugger (DAP)
------------------------------------------------------------------

local dap = require "dap"

map("n", "<leader>ds", dap.continue, { desc = "DAP: Start/Continue" })
map("n", "<leader>dc", dap.continue, { desc = "DAP: Continue" })
map("n", "<leader>dj", dap.step_over, { desc = "DAP: Step Over" })
map("n", "<leader>dk", dap.step_out, { desc = "DAP: Step Out" })
map("n", "<leader>dl", dap.step_into, { desc = "DAP: Step Into" })
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
map("n", "<leader>dr", dap.run_last, { desc = "DAP: Run Last" })
map("n", "<leader>de", dap.terminate, { desc = "DAP: Terminate" })

map("n", "<leader>dd", function()
  dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { desc = "DAP: Conditional Breakpoint" })

------------------------------------------------------------------
-- Git
------------------------------------------------------------------
-- LazyGit
map("n", "ggl", function()
  vim.cmd("terminal lazygit")
  vim.cmd("startinsert")
  vim.api.nvim_create_autocmd("TermClose", {
    pattern = "term://*lazygit",
    once = true,
    callback = function()
      vim.cmd("bd!")
    end,
  })
end, { desc = "Git: LazyGit" })

-- gitsigns
map("n", "ggt", function()
  require("gitsigns").toggle_current_line_blame()
end, { desc = "Git: Toggle blame" })

map("n", "ggs", function()
  require("gitsigns").stage_hunk()
end, { desc = "Git: Stage hunk" })

map("n", "ggr", function()
  require("gitsigns").reset_hunk()
end, { desc = "Git: Reset hunk" })

map("n", "ggp", function()
  require("gitsigns").preview_hunk()
end, { desc = "Git: Preview hunk" })

-- navigation stays same (these are standard and good)
map("n", "]h", function()
  require("gitsigns").next_hunk()
end, { desc = "Git: Next hunk" })

map("n", "[h", function()
  require("gitsigns").prev_hunk()
end, { desc = "Git: Prev hunk" })

-- fugitive
map("n", "ggb", ":G blame<CR>", { desc = "Git: Blame" })

-- diffview
map("n", "ggd", ":DiffviewOpen<CR>", { desc = "Git: Diffview open" })
map("n", "ggq", ":DiffviewClose<CR>", { desc = "Git: Diffview close" })

-- conflicts
map("n", "ggo", ":GitConflictChooseOurs<CR>", { desc = "Git: Conflict ours" })
map("n", "ggt", ":GitConflictChooseTheirs<CR>", { desc = "Git: Conflict theirs" })
map("n", "ggB", ":GitConflictChooseBoth<CR>", { desc = "Git: Conflict both" })
map("n", "gg0", ":GitConflictChooseNone<CR>", { desc = "Git: Conflict none" })
------------------------------------------------------------------
-- Language Specific
------------------------------------------------------------------

-- Rust
map("n", "<leader>ra", function()
  vim.cmd.RustLsp "hover actions"
end, { desc = "Rust: Hover actions" })

map("n", "<leader>rr", function()
  vim.cmd.RustLsp "runnables"
end, { desc = "Rust: Runnables" })

map("n", "<leader>rt", function()
  vim.cmd.RustLsp "testables"
end, { desc = "Rust: Testables" })

-- C++
map("n", "<leader>cs", "<cmd>ClangdSwitchSourceHeader<cr>", { desc = "C++: Switch source/header" })

