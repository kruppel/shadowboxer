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
    cmd = { "mise", "x", "3.4.6", "--", "solargraph", "stdio" },
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

  lspconfig.ruff.setup({
    capabilities = capabilities,
    init_options = {
      settings = {},
    },
  })

  -- Disable hover capability from Ruff since basedpyright handles it better
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == "ruff" then
        client.server_capabilities.hoverProvider = false
      end
    end,
    desc = "LSP: Disable hover capability from Ruff",
  })

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
