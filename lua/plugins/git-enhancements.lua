return {
  -- Advanced Git integration
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true,
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
    },
  },
  -- Git blame and history
  {
    "f-person/git-blame.nvim",
    event = "BufReadPre",
    config = function()
      vim.g.gitblame_enabled = 0 -- disabled by default
    end,
    keys = {
      { "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame" },
    },
  },
}
