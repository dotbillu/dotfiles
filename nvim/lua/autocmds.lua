require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local main_diag_group = augroup("UserDiagnosticsControl", { clear = true })
local oneshot_diag_group = augroup("HideDiagnosticsOnFirstChange", { clear = true })

-- 1. Hide diagnostics when typing starts
autocmd("InsertEnter", {
  group = main_diag_group,
  pattern = "*",
  callback = function()
    vim.api.nvim_clear_autocmds { group = oneshot_diag_group }
    autocmd("TextChangedI", {
      group = oneshot_diag_group,
      pattern = "*",
      callback = function()
        vim.diagnostic.config { virtual_text = false, underline = false }
        vim.api.nvim_clear_autocmds { group = oneshot_diag_group }
      end,
    })
  end,
})

-- 2. Restore diagnostics (underline only) when leaving insert mode
autocmd("InsertLeave", {
  group = main_diag_group,
  pattern = "*",
  callback = function()
    vim.api.nvim_clear_autocmds { group = oneshot_diag_group }
    vim.schedule(function()
      vim.diagnostic.config { virtual_text = false, underline = true }
    end)
  end,
})

-- 3. Kill heavy web dev LSPs gracefully before Neovim exits
autocmd("VimLeavePre", {
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

-- Automatically expand minified JSON files so they don't freeze Neovim
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.json",
  callback = function(args)
    -- Check the first line length
    local first_line = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1]
    
    -- If it's a massive one-liner...
    if first_line and string.len(first_line) > 5000 then
      -- 1. Instantly format it using 'jq' so it breaks into normal lines
      vim.cmd("%!jq .")
      
      -- 2. Save the newly formatted version so it doesn't bother you again
      vim.cmd("w")
      
      -- 3. Let you know it handled it
      vim.notify("Minified JSON detected & automatically expanded!", vim.log.levels.INFO)
    end
  end,
})
