require "nvchad.autocmds"
-- Create a group for our main, persistent autocmds
local main_diag_group = vim.api.nvim_create_augroup("UserDiagnosticsControl", { clear = true })

-- Create a temporary group for the one-shot event that will be created and destroyed repeatedly
local oneshot_diag_group = vim.api.nvim_create_augroup("HideDiagnosticsOnFirstChange", { clear = true })

local main_diag_group = vim.api.nvim_create_augroup("UserDiagnosticsControl", { clear = true })
local oneshot_diag_group = vim.api.nvim_create_augroup("HideDiagnosticsOnFirstChange", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
  group = main_diag_group,
  pattern = "*",
  callback = function()
    vim.api.nvim_clear_autocmds { group = oneshot_diag_group }
    vim.api.nvim_create_autocmd("TextChangedI", {
      group = oneshot_diag_group,
      pattern = "*",
      callback = function()
        vim.diagnostic.config { virtual_text = false, underline = false }
        vim.api.nvim_clear_autocmds { group = oneshot_diag_group }
      end,
    })
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = main_diag_group,
  pattern = "*",
  callback = function()
    vim.api.nvim_clear_autocmds { group = oneshot_diag_group }

    vim.schedule(function()
      vim.diagnostic.config { virtual_text = false, underline = true }
    end)
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    local clients = vim.lsp.get_clients()
    for _, client in ipairs(clients) do
      if client.name == "ts_ls" or client.name == "tailwindcss" or client.name == "eslint" then
        vim.lsp.stop_client(client.id)
      end
    end
    vim.cmd "sleep 100m"
  end,
})
