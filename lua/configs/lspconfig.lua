require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "ts_ls",
  "eslint",
  "clangd",
  "gopls",
  "pyright",
  "ruff",
  "rust_analyzer",
  "bashls",
  "yamlls",
  "jsonls",
  "taplo",
  "marksman",
  "graphql",
  "dartls",
}

vim.lsp.enable(servers)

vim.lsp.config("pyright", {
  settings = {
    pyright = { disableOrganizeImports = true },
    python = {
      analysis = { ignore = { "*" } },
    },
  },
})

-- Formatting is handled by Conform. ESLint stays available for diagnostics
-- without running EslintFixAll on projects that do not have an ESLint config.
