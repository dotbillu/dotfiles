-- lua/plugins/customs/rust.lua
-- Rust-specific plugins (rustaceanvim, crates.nvim)

return {
  ------------------------------------------------------------------
  -- RUST LANGUAGE SUPPORT
  ------------------------------------------------------------------
  { 
    "mrcjkb/rustaceanvim", 
    version = "^5", 
    ft = { "rust" } 
  },
  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function()
      require("crates").setup()
    end,
  },
}
