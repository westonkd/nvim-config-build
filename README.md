# LazyVim + Omarchy + Ruby/Rails Configuration

Complete Neovim configuration optimized for Ruby on Rails development in Docker containers.

## Features

- **LazyVim Base** - Modern Neovim IDE configuration
- **Omarchy Overlay** - Basecamp's Neovim setup
- **OSC 52 Clipboard** - Works in Docker containers via Ghostty terminal
- **Ruby/Rails Tools** - LSP, RSpec, vim-rails, and more
- **VS Code-like Features** - Multi-cursor (Cmd+D), advanced search
- **Git Integration** - Neogit, git-blame, diffview

## Installation

```bash
# Clone this repository to your Neovim config directory
git clone <YOUR_REPO_URL> ~/.config/nvim

# Create required directories
mkdir -p ~/.local/state/nvim/shada
mkdir -p ~/.local/share/nvim

# Start Neovim (plugins will auto-install on first launch)
nvim
```

## Key Features

### Clipboard (OSC 52)
- `<leader>y` + motion - Copy to system clipboard
- `<leader>yy` - Copy line to system clipboard
- `<leader>yp` - Copy file path
- `<leader>ya` - Toggle auto-copy on yank

### Ruby/RSpec Testing
- `<leader>tn` - Run nearest test
- `<leader>tf` - Run test file
- `<leader>ta` - Run all tests
- `<leader>tg` - Jump between implementation and spec

### Multi-Cursor (VS Code-like)
- `Cmd+D` / `Ctrl+D` - Add cursor to next match
- `Cmd+J` / `Cmd+K` - Add cursor above/below
- `Cmd+Shift+A` - Select all matches

### Advanced Search
- `<leader>srb` - Search Ruby files (no specs)
- `<leader>srs` - Search spec files only
- `<leader>sra` - Advanced search with filters
- `<leader>S` - Project-wide find & replace

### Ruby Surrounds
- `gsad` - Wrap in do..end
- `gsaf` - Wrap in def..end
- `gsac` - Wrap in class..end
- `gsai` - Wrap in if..end

## Plugin List

See `lua/plugins/` directory for all plugin configurations.

## Updates

To update this configuration:

```bash
cd ~/.config/nvim
git pull
```

## License

This is a combination of:
- [LazyVim](https://github.com/LazyVim/LazyVim) - Apache 2.0
- [Omarchy](https://github.com/basecamp/omarchy) - MIT
- Custom configurations - MIT
