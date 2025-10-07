return {
  -- VS Code-like multi-cursor support
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      -- Disable default mappings to avoid conflicts
      vim.g.VM_default_mappings = 0
      
      -- Map Cmd+D (or Ctrl+D on other systems) to add cursor to next match
      vim.g.VM_maps = {
        ["Find Under"] = "<D-d>",           -- Cmd+D on macOS
        ["Find Subword Under"] = "<D-d>",   -- Cmd+D on macOS  
        ["Add Cursor Down"] = "<D-j>",      -- Cmd+J to add cursor below
        ["Add Cursor Up"] = "<D-k>",        -- Cmd+K to add cursor above
        ["Select All"] = "<D-A>",           -- Cmd+Shift+A to select all matches
        ["Start Regex Search"] = "<D-/>",   -- Cmd+/ for regex search
        ["Visual Regex"] = "<D-/>",         -- Cmd+/ in visual mode
        ["Visual All"] = "<D-A>",           -- Cmd+Shift+A in visual mode
        ["Visual Add"] = "<D-d>",           -- Cmd+D in visual mode
        ["Visual Find"] = "<D-f>",          -- Cmd+F in visual mode
        ["Exit"] = "<Esc>",                 -- Escape to exit multi-cursor mode
      }
      
      -- Settings for better VS Code-like behavior
      vim.g.VM_highlight_matches = "underline"
      vim.g.VM_mouse_mappings = 1
      vim.g.VM_extend_selection = 0
      vim.g.VM_show_warnings = 0
    end,
    config = function()
      -- Additional keymaps for better workflow
      vim.api.nvim_set_keymap('n', '<D-d>', '<Plug>(VM-Find-Under)', {})
      vim.api.nvim_set_keymap('v', '<D-d>', '<Plug>(VM-Visual-Add)', {})
      
      -- For non-macOS systems, also map Ctrl+D
      vim.api.nvim_set_keymap('n', '<C-d>', '<Plug>(VM-Find-Under)', {})
      vim.api.nvim_set_keymap('v', '<C-d>', '<Plug>(VM-Visual-Add)', {})
    end,
  },
}
