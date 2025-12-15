# Neovim Plugins

Leader key: `Space`

## Navigation & File Management

### Neo-tree (file explorer)
- `<leader>n` - Toggle file tree
- `<leader>e` - Reveal current file in tree
- `?` - Show keybindings (inside neo-tree)

### Oil (file manager)
- `<leader>o` - Open Oil
- `-` - Go to parent directory
- `<CR>` - Select
- `<C-s>` - Vertical split
- `<C-h>` - Horizontal split
- `g.` - Toggle hidden files

### Telescope (fuzzy finder)
- `<leader>sf` - Search files
- `<leader>sg` - Search by grep (live grep)
- `<leader>sb` - Search buffers
- `<leader>sh` - Search help
- `<leader>sr` - Search recent files
- `<leader><leader>` - Find buffers

### fff.nvim (fast file finder)
- `ff` - Find files

### Barbar (tabs/buffers)
- `Tab` - Next buffer
- `Shift+Tab` - Previous buffer
- `<leader>1-5` - Go to buffer 1-5
- `<leader>bo` - Close other buffers
- `<leader>bc` - Close current buffer

### Window Picker
Used by Neo-tree for selecting windows when opening files.

---

## Git

### Gitsigns
Shows git changes in sign column + inline blame.
- No custom keybindings (auto-enabled)

### Neogit (magit-like interface)
- `<leader>gg` - Open Neogit
- `<leader>gc` - Commit
- `<leader>gp` - Push
- `<leader>gl` - Pull
- `q` - Close Neogit

### Diffview (git diff viewer)
- `<leader>do` - Diff open (all files)
- `<leader>df` - Diff current file (Gitsigns)
- `<leader>dh` - Diff file history
- `<leader>dc` - Diff close

---

## LSP & Code

### LSP (built-in)
- `gd` - Go to definition
- `gr` - Go to references
- `gI` - Go to implementation
- `K` - Hover documentation
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code action

### OmniSharp (C#)
Same as LSP, but with decompilation support via omnisharp-extended.

### Mason
LSP server installer. No keybindings, use `:Mason` command.

### Blink.cmp (autocomplete)
- `<CR>` - Accept completion
- Uses default blink.cmp keybindings

### Conform (formatting)
- `<leader>f` - Format buffer
- Auto-formats on save (except SQL)

---

## Database

### nvim-dbee
- `<leader>db` - Toggle Dbee (database UI)
- `<F5>` (normal) - Run entire file
- `<F5>` (visual) - Run selection

---

## HTTP Client

### Kulala
- `<leader>hr` - Run HTTP request
- `<leader>ha` - Run all requests
- `<leader>hp` - Previous request
- `<leader>hn` - Next request

---

## AI

### GitHub Copilot
Auto-enabled, use `Tab` to accept suggestions.

### Claude Code
- `<leader>ac` - Toggle Claude
- `<leader>af` - Focus Claude
- `<leader>ar` - Resume Claude
- `<leader>aC` - Continue Claude
- `<leader>am` - Select model
- `<leader>ab` - Add current buffer
- `<leader>as` - Send selection to Claude (visual mode)
- `<leader>as` - Add file from tree (in Neo-tree)
- `<leader>aa` - Accept diff
- `<leader>ad` - Deny diff

---

## Markdown

### render-markdown.nvim
Renders markdown with nice formatting. No keybindings.

### Markdown Preview
- `<leader>mp` - Toggle markdown preview in browser

---

## Session Management

### auto-session
- `<leader>ss` - Save session
- `<leader>sr` - Restore session
- `<leader>sd` - Delete session

---

## UI & Appearance

### Themes
- `<leader>l` - Toggle dark/light theme
- Dark: telemetry
- Light: papercolor-custom

### dark-notify
Syncs theme with macOS system appearance. No keybindings.

### Dashboard
Start screen with random facts. No keybindings.

### Barbar (buffer line)
Tab bar at top. See Navigation section for keybindings.

### Mini.statusline
Status line at bottom. No keybindings.

### indent-blankline
Rainbow indent guides. No keybindings.

### nvim-colorizer
Shows color previews in code. No keybindings.

### Which-key
Shows available keybindings when you press a key. Auto-enabled.

### Todo-comments
Highlights TODO/FIXME/NOTE in code. No keybindings.

---

## Editing

### Mini.nvim modules
- **mini.comment** - `gc` to comment
- **mini.surround** - `sa` add, `sd` delete, `sr` replace surroundings
- **mini.pairs** - Auto-close brackets
- **mini.jump** - Enhanced `f`/`t` jumping
- **mini.splitjoin** - `gS` to toggle split/join

---

## Diagnostics

- `<leader>xx` - Telescope diagnostics list
- `<leader>xd` - Show diagnostic under cursor
- `[d` / `]d` - Previous/next diagnostic

---

## General

- `<Esc>` - Clear search highlighting
- `<C-h/j/k/l>` - Move between windows
