return {
  -- Better Ruby syntax highlighting and indentation
  {
    "vim-ruby/vim-ruby",
    ft = "ruby",
  },
  -- Rails-specific enhancements with spec navigation
  {
    "tpope/vim-rails",
    ft = { "ruby", "eruby" },
    dependencies = {
      "tpope/vim-bundler",
    },
    config = function()
      -- Rails.vim provides :A command to alternate between implementation and spec
      -- e.g., from app/models/user.rb -> spec/models/user_spec.rb
    end,
  },
  -- Ruby test runner with RSpec optimizations
  {
    "vim-test/vim-test",
    keys = {
      { "<leader>tn", "<cmd>TestNearest<cr>", desc = "Run Nearest Test" },
      { "<leader>tf", "<cmd>TestFile<cr>", desc = "Run Test File" },
      { "<leader>ta", "<cmd>TestSuite<cr>", desc = "Run All Tests" },
      { "<leader>tl", "<cmd>TestLast<cr>", desc = "Run Last Test" },
      { "<leader>tg", "<cmd>TestVisit<cr>", desc = "Visit Test File" },
    },
    config = function()
      vim.g["test#strategy"] = "neovim"
      vim.g["test#neovim#term_position"] = "belowright"
      vim.g["test#echo_command"] = 1
      
      -- SET THE PROJECT ROOT to always be the main app directory
      vim.g["test#project_root"] = vim.fn.expand("~/src/app")  -- Adjust path to your app root
      
      vim.g["test#ruby#rspec#options"] = {
        nearest = "--format progress",
        file = "--format progress", 
        suite = "--format progress"
      }
      
      vim.g["test#ruby#bundle_exec"] = 1
      vim.g["test#ruby#runner"] = "rspec"
    end,
  },
}
