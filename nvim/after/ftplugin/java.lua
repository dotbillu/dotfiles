local jdtls = require "jdtls"

local root_dir = vim.fs.root(0, {
  "pom.xml",
  "mvnw",
  "gradlew",
  ".git",
})

if not root_dir then
  return
end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")

local workspace_dir = vim.fn.stdpath "data" .. "/jdtls-workspace/" .. project_name

local config = {
  cmd = {
    "java",
    "-javaagent:" .. vim.fn.stdpath "data" .. "/mason/packages/jdtls/lombok.jar",
    "-jar",
    vim.fn.stdpath "data" .. "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.7.200.v20260619-2039.jar",
    "-configuration",
    vim.fn.stdpath "data" .. "/mason/packages/jdtls/config_linux",
    "-data",
    workspace_dir,
  },

  root_dir = root_dir,

  capabilities = require("cmp_nvim_lsp").default_capabilities(),

  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },

      maven = {
        downloadSources = true,
      },

      references = {
        includeDecompiledSources = true,
      },
    },
  },

  init_options = {
    bundles = {},
  },
}
jdtls.start_or_attach(config)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
  buffer = true,
  desc = "Go to definition",
})
