return {
  "airblade/vim-gitgutter",
  event = { "BufReadPost", "BufNewFile" },
  init = function()
    vim.g.gitgutter_async = 1
    vim.g.gitgutter_map_keys = 0
    vim.opt.signcolumn = "yes"
  end,
  keys = {
    { "]c", "<Plug>(GitGutterNextHunk)", desc = "next git hunk" },
    { "[c", "<Plug>(GitGutterPrevHunk)", desc = "previous git hunk" },
    { "<leader>hs", "<Plug>(GitGutterStageHunk)", desc = "stage git hunk" },
    { "<leader>hu", "<Plug>(GitGutterUndoHunk)", desc = "undo git hunk" },
    { "<leader>hp", "<Plug>(GitGutterPreviewHunk)", desc = "preview git hunk" },
  },
}
