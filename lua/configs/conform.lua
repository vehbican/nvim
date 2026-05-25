local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    htmlangular = { "prettier" },
    graphql = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    python = { "ruff_fix", "ruff_format" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    go = { "gofmt" },
    rust = { "rustfmt" },
    dart = { "dart_format" },
    sh = { "shfmt" },
  },

  format_after_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end

    return {
      timeout_ms = 1000,
      lsp_format = "fallback",
      async = true,
    }
  end,
}

return options
