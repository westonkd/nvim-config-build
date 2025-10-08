return {
  {
    "ahmedkhalf/project.nvim",
    opts = {
      detection_methods = { "pattern" }, -- Removed "lsp" to prevent nested repo detection
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "Gemfile" },
      -- Don't treat nested git repos as separate projects
      scope_chdir = "global",
      -- Custom detection function to find outermost git repo
      manual_mode = false,
      exclude_dirs = {},
      silent_chdir = true,
      -- Show hidden files in telescope
      show_hidden = false,
    },
    event = "VeryLazy",
    config = function(_, opts)
      local project_nvim = require("project_nvim")
      
      -- Custom function to find outermost git repository
      local function find_outermost_git_root()
        local current_file = vim.fn.expand("%:p")
        if current_file == "" then
          return nil
        end
        
        local current_dir = vim.fn.fnamemodify(current_file, ":h")
        local git_root = nil
        local check_path = current_dir
        local iterations = 0
        local max_iterations = 50
        
        -- Walk up the directory tree with safety limit
        while check_path ~= "/" and iterations < max_iterations do
          if vim.fn.isdirectory(check_path .. "/.git") == 1 then
            git_root = check_path
          end
          check_path = vim.fn.fnamemodify(check_path, ":h")
          iterations = iterations + 1
        end
        
        return git_root
      end
      
      -- Override detection method
      local original_find_root = project_nvim.find_pattern_root
      
      project_nvim.find_pattern_root = function()
        local outermost = find_outermost_git_root()
        if outermost then
          return outermost
        end
        -- Fallback to original behavior if function exists
        if original_find_root then
          return original_find_root()
        end
        return nil
      end
      
      project_nvim.setup(opts)
      require("telescope").load_extension("projects")
    end,
    keys = {
      { "<leader>fp", "<Cmd>Telescope projects<CR>", desc = "Projects" },
    },
  },
}
