require "nvchad.autocmds"

-- Hide tabufline while CodeDiff is open (it uses its own tab)
vim.api.nvim_create_autocmd("User", {
  pattern = "CodeDiffOpen",
  callback = function()
    vim.g._codediff_showtabline = vim.o.showtabline
    vim.o.showtabline = 0
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "CodeDiffClose",
  callback = function()
    if vim.g._codediff_showtabline ~= nil then
      vim.o.showtabline = vim.g._codediff_showtabline
      vim.g._codediff_showtabline = nil
    end
  end,
})
