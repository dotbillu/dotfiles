-- lua/plugins/customs/cpp.lua
-- C++ specific plugins (most C++ tooling is handled by mason + dap)

return {
  -- C++ specific plugins can be added here in the future
  -- Currently, C++ support is provided through:
  -- - clangd (LSP) via mason in common.lua
  -- - clang-format (formatter) via conform in common.lua
  -- - codelldb/cpptools (debugger) via mason-nvim-dap in dap.lua
  -- - treesitter c/cpp parsers in common.lua
}