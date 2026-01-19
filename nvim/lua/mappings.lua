require "nvchad.mappings"
local map = vim.keymap.set
------------------------------------------------------------------
-- General Mappings
------------------------------------------------------------------
--tree toggle
map("n", "t", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle nvim-tree" })

-- Enter command mode with ;
map("n", ";", ":", { desc = "CMD: Enter command mode" })

-- A popular mapping to exit insert mode
map("i", "jk", "<ESC>", { desc = "KEYS: Escape insert mode" })

map("n", "<leader>cl", "<cmd>Telescope keymaps<cr>", { desc = "LIST: Keymaps (Telescope)" })

map("x", "p", [["_dP]], { desc = "paste without copy" })
map("v", "x", [["_d]], { desc = "Delete selection without copying" })
map("n", "<leader>sr", "<cmd>GrugFar<CR>", { desc = "Search and Replace (Grug-far)" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { desc = "FILE: Save" })

------------------------------------------------------------------
-- Debugger (DAP) Mappings
------------------------------------------------------------------

-- Require 'dap' once to improve performance
local dap = require "dap"

-- This keymap starts a new debug session if none is active
map("n", "<leader>ds", dap.continue, { desc = "DAP: Start/Continue" })
map("n", "<leader>dc", dap.continue, { desc = "DAP: Continue" })
map("n", "<leader>dj", dap.step_over, { desc = "DAP: Step Over" })
map("n", "<leader>dk", dap.step_out, { desc = "DAP: Step Out" })
map("n", "<leader>dl", dap.step_into, { desc = "DAP: Step Into" })
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
map("n", "<leader>dr", dap.run_last, { desc = "DAP: Run Last" })
map("n", "<leader>de", dap.terminate, { desc = "DAP: Terminate Session" })
map("n", "<leader>dd", function()
  dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { desc = "DAP: Set Conditional Breakpoint" })
------------------------------------------------------------------
-- Rust (`rustaceanvim`) Mappings
------------------------------------------------------------------

-- The <leader>r prefix is used for Rust-specific actions
map("n", "<leader>ra", function()
  vim.cmd.RustLsp "hover actions"
end, { desc = "RUST: Hover Actions" })
map("n", "<leader>rr", function()
  vim.com.RustLsp "runnables"
end, { desc = "RUST: Runnables" })
map("n", "<leader>rt", function()
  vim.cmd.RustLsp "testables"
end, { desc = "RUST: Testables" })

------------------------------------------------------------------
-- C++ Mappings
------------------------------------------------------------------

-- The <leader>c prefix is used for C/C++ specific actions
map("n", "<leader>cs", "<cmd>ClangdSwitchSourceHeader<cr>", { desc = "C++: Switch Source/Header" })
