-- lua/plugins/customs/webdev.lua
-- Web development/JS/TS plugins (ts-autotag; other LSPs via mason)

return {
  ------------------------------------------------------------------
  -- WEB DEVELOPMENT PLUGINS
  ------------------------------------------------------------------
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascriptreact", "typescriptreact", "vue" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  
  -- Note: Other web development LSPs are handled via mason in common.lua:
  -- - typescript-language-server (ts_ls)
  -- - tailwindcss-language-server
  -- - eslint-lsp
  -- - css-lsp (cssls)
  -- - html-lsp (html)
  -- - json-lsp (jsonls)
  -- - prettier (formatter)
}