return {
  "tpope/vim-fugitive",
  keys = {
    { "<leader>gr", "<cmd>Gread<cr>", desc = "read file from git" },
    { "<leader>gb", "<cmd>G blame<cr>", desc = "read file from git" },
  },
  dependencies = { "tpope/vim-rhubarb" },
}
