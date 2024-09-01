local function config()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  local lspconfig = require("lspconfig")
  local servers = {
    lspconfig.bashls,
    lspconfig.eslint,
    lspconfig.rubocop,
    -- lspconfig.ruby_lsp,
    lspconfig.tsserver,
  }

  for _, server in ipairs(servers) do
    server.setup({ capabilities = capabilities })
  end

  lspconfig.solargraph.setup({
    cmd = { "solargraph", "stdio" },
    filetypes = { "ruby" },
    init_options = {
      formatting = true,
    },
    settings = {
      solargraph = {
        diagnostics = true,
      },
    },
  })
  -- Language servers can be configured on a per-project basis using exrc.
  -- See the .nvim.lua file in .dotfiles for an example.
end

return {
  "neovim/nvim-lspconfig",
  config = config,
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason-lspconfig.nvim",
  },
}
