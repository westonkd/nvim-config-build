-- Completely prevent Mason from managing ruby_lsp
return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- Remove ruby-lsp from ensure_installed
      opts.ensure_installed = vim.tbl_filter(function(pkg)
        return pkg ~= "ruby-lsp"
      end, opts.ensure_installed)
      return opts
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- Remove ruby_lsp from auto-install
      opts.ensure_installed = vim.tbl_filter(function(server)
        return server ~= "ruby_lsp" and server ~= "ruby-lsp"
      end, opts.ensure_installed)
      return opts
    end,
  },
}
