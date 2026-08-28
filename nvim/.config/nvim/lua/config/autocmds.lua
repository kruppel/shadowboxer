-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatexpr = ""
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    if vim.bo[args.buf].filetype == "markdown" then
      vim.opt_local.formatexpr = ""
    end
  end,
})
