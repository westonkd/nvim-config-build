return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Disable solargraph completely - only use ruby_lsp
      servers = {
        solargraph = false, -- Explicitly disable
        
        ruby_lsp = {
          -- Use bundle exec to ensure ruby-lsp uses the correct bundler context
          cmd = { "bundle", "exec", "ruby-lsp" },
          
          -- Custom root_dir function to always use outermost git repo
          root_dir = function(fname)
            local util = require("lspconfig.util")

            -- Helper function to find outermost git root with safety checks
            local function find_outermost_git_root(path)
              if not path or path == "" then
                return nil
              end
              
              local current_path = path
              local git_root = nil
              local max_iter = 50
              local iter = 0

              -- Walk up the directory tree with iteration limit
              while current_path ~= "/" and iter < max_iter do
                if vim.fn.isdirectory(current_path .. "/.git") == 1 then
                  git_root = current_path
                end
                local parent = vim.fn.fnamemodify(current_path, ":h")
                -- Prevent infinite loop if parent is same as current
                if parent == current_path then
                  break
                end
                current_path = parent
                iter = iter + 1
              end

              return git_root
            end

            -- Start from the file's directory
            local start_path = vim.fn.fnamemodify(fname, ":h")
            local outermost_root = find_outermost_git_root(start_path)

            if outermost_root then
              return outermost_root
            end

            -- Fallback to default ruby_lsp root detection
            return util.root_pattern("Gemfile", ".git")(fname)
          end,

          -- Additional settings for ruby_lsp
          init_options = {
            enabledFeatures = {
              "documentHighlights",
              "documentSymbols",
              "foldingRanges",
              "selectionRanges",
              "semanticHighlighting",
              "formatting",
              "codeActions",
            },
          },
          settings = {},
        },
      },
    },
  },
}
