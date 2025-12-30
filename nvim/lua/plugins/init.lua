-- lua/plugins/init.lua
-- Main plugin loader that imports modular plugin configurations

return {
  -- Import modular plugin configurations
  { import = "plugins.customs.common" }, -- Core tooling, editor enhancements
  { import = "plugins.customs.dap" }, -- Debugging plugins
  { import = "plugins.customs.cpp" }, -- C++ specific plugins
  { import = "plugins.customs.rust" }, -- Rust specific plugins
  { import = "plugins.customs.webdev" }, -- Web development plugins
  { import = "plugins.customs.python" }, --python plugins
}
