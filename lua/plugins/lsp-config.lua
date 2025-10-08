return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          -- Custom root_dir function to always use outermost git repo
          root_dir = function(fname)
            local util = require("lspconfig.util")
            
            -- Helper function to find outermost git root
            local function find_outermost_git_root(path)
              local current_path = path
              local git_root = nil
              
              -- Walk up the directory tree
              while current_path ~= "/" do
                if vim.fn.isdirectory(current_path .. "/.git") == 1 then
                  git_root = current_path
                end
                current_path = vim.fn.fnamemodify(current_path, ":h")
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
        
        -- Configure solargraph the same way (in case you switch)
        solargraph = {
          root_dir = function(fname)
            local util = require("lspconfig.util")
            
            local function find_outermost_git_root(path)
              local current_path = path
              local git_root = nil
              
              while current_path ~= "/" do
                if vim.fn.isdirectory(current_path .. "/.git") == 1 then
                  git_root = current_path
                end
                current_path = vim.fn.fnamemodify(current_path, ":h")
              end
              
              return git_root
            end
            
            local start_path = vim.fn.fnamemodify(fname, ":h")
            local outermost_root = find_outermost_git_root(start_path)
            
            if outermost_root then
              return outermost_root
            end
            
            return util.root_pattern("Gemfile", ".git")(fname)
          end,
        },
      },
    },
  },
}
