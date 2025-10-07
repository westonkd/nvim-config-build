return {
  -- Enhanced clipboard configuration for container/remote environments
  {
    "ojroques/nvim-osc52",
    event = "VeryLazy",
    config = function()
      require('osc52').setup({
        max_length = 0,      -- Maximum length of selection (0 for no limit)
        silent = false,      -- Disable message on successful copy
        trim = false,        -- Trim surrounding whitespaces before copy
      })

      -- Keybindings for clipboard operations
      local opts = { desc = 'Copy to system clipboard' }
      vim.keymap.set('v', '<leader>y', require('osc52').copy_visual, opts)
      vim.keymap.set('n', '<leader>y', function() 
        require('osc52').copy_operator() 
      end, { desc = 'Copy motion to system clipboard' })
      vim.keymap.set('n', '<leader>yy', function()
        vim.cmd('normal! yy')
        require('osc52').copy(vim.fn.getreg('"'))
      end, { desc = 'Copy line to system clipboard' })
      
      -- Copy current file path to clipboard
      vim.keymap.set('n', '<leader>yp', function()
        local path = vim.fn.expand('%')
        require('osc52').copy(path)
        vim.notify('Copied: ' .. path, vim.log.levels.INFO)
      end, { desc = 'Copy relative file path' })
      
      -- Copy absolute file path to clipboard
      vim.keymap.set('n', '<leader>yP', function()
        local path = vim.fn.expand('%:p')
        require('osc52').copy(path)
        vim.notify('Copied: ' .. path, vim.log.levels.INFO)
      end, { desc = 'Copy absolute file path' })
      
      -- Copy file path and line number (useful for sharing code locations)
      vim.keymap.set('n', '<leader>yl', function()
        local path = vim.fn.expand('%')
        local line = vim.fn.line('.')
        local location = path .. ':' .. line
        require('osc52').copy(location)
        vim.notify('Copied: ' .. location, vim.log.levels.INFO)
      end, { desc = 'Copy file path with line number' })
      
      -- Auto-copy to system clipboard on yank (optional, can be toggled)
      local auto_copy_enabled = false
      vim.keymap.set('n', '<leader>ya', function()
        auto_copy_enabled = not auto_copy_enabled
        if auto_copy_enabled then
          vim.api.nvim_create_autocmd('TextYankPost', {
            group = vim.api.nvim_create_augroup('osc52_auto_copy', { clear = true }),
            callback = function()
              if vim.v.event.operator == 'y' then
                require('osc52').copy(vim.fn.getreg('"'))
              end
            end,
          })
          vim.notify('Auto-copy to clipboard: ENABLED', vim.log.levels.INFO)
        else
          pcall(vim.api.nvim_del_augroup_by_name, 'osc52_auto_copy')
          vim.notify('Auto-copy to clipboard: DISABLED', vim.log.levels.INFO)
        end
      end, { desc = 'Toggle auto-copy to system clipboard on yank' })
    end,
  },
}
