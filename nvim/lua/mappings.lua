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
-- Common tools
------------------------------------------------------------------

local ufo = require "ufo"

map("n", "zR", function()
  ufo.openAllFolds()
end, { desc = "Fold: Open all" })

map("n", "zM", function()
  ufo.closeAllFolds()
end, { desc = "Fold: Close all" })

map("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Markdown: Preview" })

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
require("which-key").add {
  { "ga", group = "Git" },
}

-- LazyGit
map("n", "gal", function()
  vim.cmd "terminal lazygit"
  vim.cmd "startinsert"
  vim.api.nvim_create_autocmd("TermClose", {
    pattern = "term://*lazygit",
    once = true,
    callback = function()
      vim.cmd "bd!"
    end,
  })
end, { desc = "Git: LazyGit" })

-- Hunks
map("n", "gas", function()
  require("gitsigns").stage_hunk()
end, { desc = "Git: Stage hunk" })

map("n", "gar", function()
  require("gitsigns").reset_hunk()
end, { desc = "Git: Reset hunk" })

map("n", "gap", function()
  require("gitsigns").preview_hunk()
end, { desc = "Git: Preview hunk" })

map("n", "gat", function()
  require("gitsigns").toggle_current_line_blame()
end, { desc = "Git: Toggle blame" })

-- Navigation
map("n", "gan", function()
  require("gitsigns").next_hunk()
end, { desc = "Git: Next hunk" })

map("n", "gaN", function()
  require("gitsigns").prev_hunk()
end, { desc = "Git: Prev hunk" })

-- Views
map("n", "gab", ":G blame<CR>", { desc = "Git: Blame" })
map("n", "gad", ":DiffviewOpen<CR>", { desc = "Git: Diffview open" })
map("n", "gaq", ":DiffviewClose<CR>", { desc = "Git: Diffview close" })

-- Conflicts
map("n", "gao", ":GitConflictChooseOurs<CR>", { desc = "Git: Conflict ours" })
map("n", "gaT", ":GitConflictChooseTheirs<CR>", { desc = "Git: Conflict theirs" })
map("n", "gaB", ":GitConflictChooseBoth<CR>", { desc = "Git: Conflict both" })
map("n", "ga0", ":GitConflictChooseNone<CR>", { desc = "Git: Conflict none" })

-- Telescope Git
map("n", "gaf", "<cmd>Telescope git_files<CR>", { desc = "Git: Files" })
map("n", "gac", "<cmd>Telescope git_commits<CR>", { desc = "Git: Commits" })
map("n", "gaC", "<cmd>Telescope git_bcommits<CR>", { desc = "Git: Buffer commits" })
map("n", "gaS", "<cmd>Telescope git_status<CR>", { desc = "Git: Status" })
map("n", "gaR", "<cmd>Telescope git_branches<CR>", { desc = "Git: Branches" })

pcall(vim.keymap.del, "n", "<leader>cm")
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

--Web
require "nvchad.mappings"

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
local map = vim.keymap.set
-- LazyGit
map("n", "<leader>gl", function()
  vim.cmd "terminal lazygit"
  vim.cmd "startinsert"
  vim.api.nvim_create_autocmd("TermClose", {
    pattern = "term://*lazygit",
    once = true,
    callback = function()
      vim.cmd "bd!"
    end,
  })
end, { desc = "Git: LazyGit" })

-- Hunks
map("n", "<leader>gs", function()
  require("gitsigns").stage_hunk()
end, { desc = "Git: Stage hunk" })
map("n", "<leader>gr", function()
  require("gitsigns").reset_hunk()
end, { desc = "Git: Reset hunk" })
map("n", "<leader>gp", function()
  require("gitsigns").preview_hunk()
end, { desc = "Git: Preview hunk" })
map("n", "<leader>gt", function()
  require("gitsigns").toggle_current_line_blame()
end, { desc = "Git: Toggle blame" })

-- Navigation
map("n", "<leader>gn", function()
  require("gitsigns").next_hunk()
end, { desc = "Git: Next hunk" })
map("n", "<leader>gN", function()
  require("gitsigns").prev_hunk()
end, { desc = "Git: Prev hunk" })

-- Views
map("n", "<leader>gb", ":G blame<CR>", { desc = "Git: Blame" })
map("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Git: Diffview open" })
map("n", "<leader>gq", ":DiffviewClose<CR>", { desc = "Git: Diffview close" })

-- Conflicts
map("n", "<leader>go", ":GitConflictChooseOurs<CR>", { desc = "Git: Conflict ours" })
map("n", "<leader>gT", ":GitConflictChooseTheirs<CR>", { desc = "Git: Conflict theirs" })
map("n", "<leader>gB", ":GitConflictChooseBoth<CR>", { desc = "Git: Conflict both" })
map("n", "<leader>g0", ":GitConflictChooseNone<CR>", { desc = "Git: Conflict none" })

-- Telescope Git
map("n", "<leader>gf", "<cmd>Telescope git_files<CR>", { desc = "Git: Files" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git: Commits" })
map("n", "<leader>gC", "<cmd>Telescope git_bcommits<CR>", { desc = "Git: Buffer commits" })
map("n", "<leader>gS", "<cmd>Telescope git_status<CR>", { desc = "Git: Status" })
map("n", "<leader>gR", "<cmd>Telescope git_branches<CR>", { desc = "Git: Branches" })

pcall(vim.keymap.del, "n", "<leader>cm")
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

--core
map("n", "<leader>i", function()
  local image = require "image"
  image.toggle()
end, { desc = "Toggle image preview" })

map("n", "<leader>ca", function()
  require("nvchad.tabufline").closeAllBufs()
end, { desc = "Close all buffers" })

map("n", "<leader>cq", "<cmd>qa!<CR>", { desc = "Force quit everything" })

map("n", "<C-S-P>", function()
  local ext = vim.fn.expand("%:e")
  
  local tmp_file = "/tmp/nvim_clipboard." .. (ext ~= "" and ext or "txt")
  
  -- 3. Dump the Wayland clipboard directly to the temp file
  os.execute("wl-paste > " .. tmp_file)
  
  -- 4. Format the file silently in the background
  if ext == "json" then
    -- Format with jq, hide errors, and overwrite
    os.execute("jq . " .. tmp_file .. " > " .. tmp_file .. "_fmt 2>/dev/null && mv " .. tmp_file .. "_fmt " .. tmp_file)
  elseif ext ~= "" then
    -- Format with Prettier in-place, discarding all error messages to the void
    os.execute("prettier --write " .. tmp_file .. " > /dev/null 2>&1")
  end
  
  -- 5. Read the clean file into Neovim instantly
  vim.cmd("r " .. tmp_file)
  
  -- 6. Clean up the evidence
  os.execute("rm -f " .. tmp_file)
  
  vim.notify("Smart Paste Complete!", vim.log.levels.INFO)
end, { desc = "Bulletproof Smart Paste" })
