-- Default LazyVim options
-- Add any additional options here

-- LSP Server to use for Ruby.
-- Set to "solargraph" to use solargraph instead of ruby_lsp.
vim.g.lazyvim_ruby_lsp = "ruby_lsp"
vim.g.lazyvim_ruby_formatter = "rubocop"

-- OSC 52 clipboard integration for remote/container environments
-- This enables clipboard sharing between Neovim in Docker and macOS via Ghostty
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}

-- Docker/Container specific settings
if vim.fn.isdirectory('/usr/src/app') == 1 then
  -- Set reasonable defaults for container environments
  vim.opt.updatetime = 1000  -- Slightly longer for container performance
  vim.opt.timeoutlen = 500   -- Faster key sequence timeout
  
  -- Better file watching in containers
  vim.opt.backup = false
  vim.opt.writebackup = false
  vim.opt.swapfile = false
end

-- Ruby specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby", "eruby" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})
