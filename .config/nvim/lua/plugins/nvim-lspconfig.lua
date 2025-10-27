local function config()
  local capabilities = require("blink.cmp").get_lsp_capabilities()
  local lspconfig = require("lspconfig")
  local servers = {
    lspconfig.bashls,
    lspconfig.eslint,
    lspconfig.solargraph,
    lspconfig.rubocop,
    -- lspconfig.ruby_lsp,
    lspconfig.tsserver,
    -- lspconfig.ruff,
  }

  for _, server in ipairs(servers) do
    server.setup({ capabilities = capabilities })
  end

  lspconfig.rubocop.setup({
    cmd = { "bundle", "exec", "rubocop", "--lsp" },
    root_dir = lspconfig.util.root_pattern("Gemfile", ".git", "."),
  })

  lspconfig.solargraph.setup({
    cmd = { "chruby-exec", "3.3.5", "--", "solargraph", "stdio" },
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

  lspconfig.basedpyright.setup({
    capabilities = capabilities,
    settings = {
      basedpyright = {
        analysis = {
          typeCheckingMode = "standard",
          diagnosticMode = "openFilesOnly",
        },
      },
    },
  })

  -- lspconfig.ruff.setup({
  --   cmd = { "ruff-lsp" },
  --   filetypes = { "python" },
  --   root_dir = lspconfig.util.root_pattern("pyproject.toml", ".git"),
  -- })
  -- Language servers can be configured on a per-project basis using exrc.
  -- See the .nvim.lua file in .dotfiles for an example.
end

return {
  "neovim/nvim-lspconfig",
  config = config,
  dependencies = {
    "saghen/blink.cmp",
    "mason-org/mason-lspconfig.nvim",
  },
}
