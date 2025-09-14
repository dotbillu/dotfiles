require "nvchad.autocmds"
-- Create a group for our main, persistent autocmds
local main_diag_group = vim.api.nvim_create_augroup("UserDiagnosticsControl", { clear = true })

-- Create a temporary group for the one-shot event that will be created and destroyed repeatedly
local oneshot_diag_group = vim.api.nvim_create_augroup("HideDiagnosticsOnFirstChange", { clear = true })

-- When you ENTER Insert Mode:
vim.api.nvim_create_autocmd("InsertEnter", {
  group = main_diag_group,
  pattern = "*",
  callback = function()
    -- Set up a one-time event to hide diagnostics ONCE you start typing.
    vim.api.nvim_create_autocmd("TextChangedI", {
      group = oneshot_diag_group, -- Use the temporary group
      pattern = "*",
      callback = function()
        -- This runs when you type the first character
        vim.diagnostic.config({
          virtual_text = false,
          underline = false,
        })
        -- Clear the temporary group to "delete" this autocmd
        vim.api.nvim_clear_autocmds({ group = oneshot_diag_group })
      end,
    })
  end,
})

-- When you LEAVE Insert Mode:
vim.api.nvim_create_autocmd("InsertLeave", {
  group = main_diag_group,
  pattern = "*",
  callback = function()
    -- THE FIX: Defer showing diagnostics until Neovim is ready.
    vim.schedule(function()
      vim.diagnostic.config({
        virtual_text = false,
        underline = true,
      })
    end)
    -- Clean up the temporary autocmd just in case.
    vim.api.nvim_clear_autocmds({ group = oneshot_diag_group })
  end,
})
