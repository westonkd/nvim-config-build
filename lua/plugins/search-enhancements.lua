return {
  -- Enhanced Telescope with better search capabilities
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local lga_actions = require("telescope-live-grep-args.actions")
      
      telescope.setup({
        defaults = {
          -- Better file preview
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          -- Note: cwd is set dynamically in each search function to use outermost git root
          -- Exclude common directories that shouldn't be searched
          file_ignore_patterns = {
            "node_modules/.*",
            "%.git/.*",
            "packages/.*",
            "vendor/bundle/.*",
            "tmp/.*",
            "log/.*",
            "coverage/.*",
            "%.min%.js",
            "%.min%.css",
            "dist/.*",
            "build/.*",
            "%.lock",
          },
        },
        extensions = {
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                ["<C-f>"] = lga_actions.quote_prompt({ postfix = " -t" }),
              },
            },
          },
        },
      })
      
      -- Load extensions
      telescope.load_extension("live_grep_args")
      telescope.load_extension("fzf")
      
      -- Custom search functions for Ruby workflow
      local builtin = require("telescope.builtin")
      
      -- Helper to get root directory (uses LazyVim's detection)
      local function get_root()
        return vim.b.lazyvim_root_dir or vim.fn.getcwd()
      end
      
      -- Search in Ruby files (excluding specs) - always from git root
      vim.keymap.set("n", "<leader>srb", function()
        builtin.live_grep({
          prompt_title = "Search Ruby Files (no specs)",
          cwd = get_root(),
          glob_pattern = "*.rb",
          additional_args = { "--glob", "!*spec.rb", "--glob", "!*_spec.rb" }
        })
      end, { desc = "Search Ruby files (no specs)" })
      
      -- Search only in spec files - always from git root
      vim.keymap.set("n", "<leader>srs", function()
        builtin.live_grep({
          prompt_title = "Search Spec Files",
          cwd = get_root(),
          glob_pattern = { "*spec.rb", "*_spec.rb" }
        })
      end, { desc = "Search spec files" })
      
      -- Advanced search with file patterns (like VS Code Ctrl+Shift+F)
      vim.keymap.set("n", "<leader>sra", function()
        require("telescope").extensions.live_grep_args.live_grep_args({
          prompt_title = "Advanced Search with Filters",
          cwd = get_root(),
        })
      end, { desc = "Advanced search with file patterns" })
      
      -- Search in specific directories
      vim.keymap.set("n", "<leader>srd", function()
        builtin.live_grep({
          prompt_title = "Search in Directory",
          search_dirs = { vim.fn.input("Directory: ", "", "dir") }
        })
      end, { desc = "Search in specific directory" })
      
      -- Quick search current word in Ruby files (no specs)
      vim.keymap.set("n", "<leader>swrb", function()
        builtin.grep_string({
          prompt_title = "Search Word in Ruby Files",
          cwd = get_root(),
          glob_pattern = "*.rb",
          additional_args = { "--glob", "!*spec.rb", "--glob", "!*_spec.rb" }
        })
      end, { desc = "Search current word in Ruby files" })
      
      -- Quick search current word in spec files
      vim.keymap.set("n", "<leader>swrs", function()
        builtin.grep_string({
          prompt_title = "Search Word in Spec Files",
          cwd = get_root(),
          glob_pattern = { "*spec.rb", "*_spec.rb" }
        })
      end, { desc = "Search current word in spec files" })
    end,
    keys = {
      -- Override default keymaps to use LazyVim's root detection
      { "<leader>sg", function()
        -- Use LazyVim's root_dir if available, otherwise current working directory
        local root = vim.b.lazyvim_root_dir or vim.fn.getcwd()
        require("telescope.builtin").live_grep({ cwd = root })
      end, desc = "Live Grep (All Files)" },
      
      { "<leader>sw", function()
        local root = vim.b.lazyvim_root_dir or vim.fn.getcwd()
        require("telescope.builtin").grep_string({ cwd = root })
      end, desc = "Search Word Under Cursor" },
      
      { "<leader>sf", function()
        local root = vim.b.lazyvim_root_dir or vim.fn.getcwd()
        require("telescope.builtin").find_files({ cwd = root })
      end, desc = "Find Files" },
      
      { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume Last Search" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
    },
  },
  
  -- Better grep with ripgrep args
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    version = "^1.0.0",
  },
  
  -- Faster fuzzy finding with fzf
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  
  -- Project-wide find and replace
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("spectre").setup({
        color_devicons = true,
        highlight = {
          ui = "String",
          search = "DiffChange",
          replace = "DiffDelete"
        },
        mapping = {
          ['send_to_qf'] = {
            map = "<C-q>",
            cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
            desc = "send all items to quickfix"
          },
        },
      })
    end,
    keys = {
      { "<leader>S", "<cmd>lua require('spectre').toggle()<cr>", desc = "Toggle Spectre (Find & Replace)" },
      { "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", desc = "Search Current Word" },
      { "<leader>sw", "<esc><cmd>lua require('spectre').open_visual()<cr>", mode = "v", desc = "Search Current Selection" },
      { "<leader>sp", "<cmd>lua require('spectre').open_file_search({select_word=true})<cr>", desc = "Search in Current File" },
    },
  },
}
