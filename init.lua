-- Minimal Neovim config: Dashboard + Neo-tree + Statusline

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd Font
vim.g.have_nerd_font = true

-- Detect system theme (macOS)
local function is_dark_mode()
    if vim.fn.has 'mac' == 1 then
        local handle = io.popen [[osascript -e 'tell application "System Events" to tell appearance preferences to return dark mode']]
        if handle then
            local result = handle:read '*a'
            handle:close()
            return result:match 'true' ~= nil
        end
    end
    return true -- default to dark
end

vim.g.system_theme_is_dark = is_dark_mode()

-- [[ Options ]]
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.hlsearch = true
vim.opt.hidden = true
vim.opt.termguicolors = true
vim.o.background = 'dark'
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.guicursor = 'n-v-c:block-Cursor,i-ci-ve:block-iCursor-blinkon500-blinkoff500,r-cr:hor20,o:hor50'

-- [[ Keymaps ]]
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Toggle dark/light
local function apply_cterm_highlights()
    if vim.o.background == 'dark' then
        vim.cmd [[hi CursorLineNr ctermfg=208 ctermbg=NONE]]
        vim.cmd [[hi DashboardHeader ctermfg=223 guifg=#5a6570]]
        vim.cmd [[hi DashboardFooter ctermfg=12 guifg=#5C6773]]
    else
        vim.cmd [[hi CursorLineNr ctermfg=27  ctermbg=NONE]]
        vim.cmd [[hi DashboardHeader ctermfg=0 guifg=#5c6773]]
        vim.cmd [[hi DashboardFooter ctermfg=4 guifg=#5C6773]]
    end
end

vim.keymap.set('n', '<leader>l', function()
    if vim.o.background == 'dark' then
        vim.o.background = 'light'
        vim.cmd 'colorscheme PaperColor'
    else
        vim.o.background = 'dark'
        vim.cmd 'colorscheme telemetry'
        -- Transparent background
        local fg = '#9abfbe'
        vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE', fg = fg })
        vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'NONE', fg = fg })
        vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
        vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'NONE' })
        vim.api.nvim_set_hl(0, 'LineNr', { bg = 'NONE' })
        vim.api.nvim_set_hl(0, 'WinSeparator', { bg = 'NONE' })
        vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg = 'NONE' })
        vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { bg = 'NONE' })
        vim.api.nvim_set_hl(0, 'NeoTreeEndOfBuffer', { bg = 'NONE', fg = '#0F1B1D' })
        vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = 'NONE' })
        vim.api.nvim_set_hl(0, 'RenderMarkdownCodeInline', { bg = 'NONE' })
        -- Remove header background highlights
        for i = 1, 6 do
            vim.api.nvim_set_hl(0, 'RenderMarkdownH' .. i .. 'Bg', { bg = 'NONE' })
        end
    end
    apply_cterm_highlights()
    vim.cmd 'doautocmd ColorScheme'
end, { desc = 'Toggle Dark/Light' })

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Close dashboard when opening a file
vim.api.nvim_create_autocmd('BufReadPre', {
    callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == 'dashboard' then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end
    end,
})

-- VimEnter setup
vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
        vim.defer_fn(function()
            apply_cterm_highlights()
            vim.opt.fillchars = { vert = ' ', eob = ' ' }
            if vim.g.system_theme_is_dark then
                vim.api.nvim_set_hl(0, 'WinSeparator', { bg = '#0F1B1D' })
            end
        end, 50)
    end,
})

-- Добавляем Mason bin в PATH
vim.env.PATH = vim.fn.stdpath 'data' .. '/mason/bin:' .. vim.env.PATH

-- [[ LSP Configuration (vim.lsp.config API for Neovim 0.11+) ]]
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end
        map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
        map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    end,
})

-- LSP servers config
vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
        },
    },
})

vim.lsp.config('sqls', {
    cmd = { 'sqls' },
    filetypes = { 'sql', 'mysql', 'plsql' },
})

-- omnisharp конфигурируется после lazy.setup (см. ниже)

vim.lsp.config('ts_ls', {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
})

vim.lsp.config('jsonls', {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
})

vim.lsp.config('lemminx', {
    cmd = { 'lemminx' },
    filetypes = { 'xml', 'xsd', 'xsl', 'xslt', 'svg' },
})

vim.lsp.config('marksman', {
    cmd = { 'marksman', 'server' },
    filetypes = { 'markdown', 'markdown.mdx' },
})

vim.lsp.config('intelephense', {
    cmd = { 'intelephense', '--stdio' },
    filetypes = { 'php' },
})

-- Enable LSP servers (omnisharp включается отдельно после lazy.setup)
vim.lsp.enable { 'lua_ls', 'sqls', 'ts_ls', 'jsonls', 'lemminx', 'marksman', 'intelephense' }

-- [[ Lazy.nvim plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Plugins ]]
require('lazy').setup({
    -- Gruvbox тема (dark)
    {
        'morhetz/gruvbox',
        priority = 1000,
        config = function()
            vim.g.gruvbox_contrast_dark = 'hard'
            vim.g.gruvbox_italic = 1

            -- Apply theme based on system preference
            if vim.g.system_theme_is_dark then
                vim.cmd 'colorscheme telemetry'
                -- Transparent background
                local fg = '#9abfbe'
                vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE', fg = fg })
                vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'NONE', fg = fg })
                vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
                vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'NONE' })
                vim.api.nvim_set_hl(0, 'LineNr', { bg = 'NONE' })
                vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg = 'NONE' })
                vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { bg = 'NONE' })
                vim.api.nvim_set_hl(0, 'NeoTreeEndOfBuffer', { bg = 'NONE', fg = '#0F1B1D' })
                vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = 'NONE' })
                vim.api.nvim_set_hl(0, 'RenderMarkdownCodeInline', { bg = 'NONE' })
                -- Remove header background highlights
                for i = 1, 6 do
                    vim.api.nvim_set_hl(0, 'RenderMarkdownH' .. i .. 'Bg', { bg = 'NONE' })
                end
            else
                vim.o.background = 'light'
                vim.cmd 'colorscheme PaperColor'
            end
        end,
    },

    -- Альтернативные темы
    { 'Shatur/neovim-ayu', lazy = true },
    { 'shaunsingh/nord.nvim', lazy = true },
    { 'sainnhe/everforest', lazy = true },
    { 'joshdick/onedark.vim', lazy = true },
    { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
    { 'rebelot/kanagawa.nvim', lazy = true },
    { 'rose-pine/neovim', name = 'rose-pine', lazy = true },

    -- PaperColor тема (light)
    {
        'NLKNguyen/papercolor-theme',
        priority = 1000,
        init = function()
            vim.g.PaperColor_Theme_Options = {
                theme = {
                    ['default.light'] = {
                        override = {
                            color10 = { '#cc0058', '233' },
                            color14 = { '#004d99', '233' },
                            color07 = { '#3d425c', '233' },
                        },
                    },
                },
            }
        end,
    },

    -- Icons (must load first)
    {
        'nvim-tree/nvim-web-devicons',
        enabled = vim.g.have_nerd_font,
        lazy = false,
        priority = 999,
        config = function()
            require('nvim-web-devicons').setup {
                default = true,
                override_by_extension = {
                    ['md'] = {
                        icon = '',
                        color = '#d49a4f',
                        cterm_color = '179',
                        name = 'Md',
                    },
                    ['sql'] = {
                        icon = '',
                        color = '#d49a4f',
                        cterm_color = '179',
                        name = 'Sql',
                    },
                },
                override_by_filename = {
                    ['README.md'] = {
                        icon = '',
                        color = '#8dac8b',
                        cterm_color = '108',
                        name = 'Readme',
                    },
                },
            }
        end,
    },

    -- Neo-tree (file explorer)
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        lazy = false,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            require('neo-tree').setup {
                source_selector = {
                    statusline = false,
                },
                filesystem = {
                    follow_current_file = { enabled = true },
                    filtered_items = {
                        visible = true,
                        hide_dotfiles = false,
                        hide_gitignored = false,
                    },
                },
                default_component_configs = {
                    git_status = {
                        symbols = {
                            added = 'ﱈ',
                            deleted = '',
                            modified = '',
                            renamed = '󰑕',
                            untracked = '+',
                            ignored = '',
                            unstaged = '',
                            staged = '',
                            conflict = '',
                        },
                    },
                },
            }
            -- Custom highlights for dark theme
            local function apply_custom_highlights()
                local is_dark = vim.o.background == 'dark'
                local folder_icon = is_dark and '#c27166' or '#af0000'
                vim.api.nvim_set_hl(0, 'NeoTreeDirectoryIcon', { fg = folder_icon })
                vim.api.nvim_set_hl(0, 'DiffviewFolderSign', { fg = folder_icon })
                if is_dark then
                    -- Telemetry theme colors
                    local bg_dark = '#0F1B1D'
                    local bg_alt = '#162224'
                    local fg = '#e0f0ef'
                    local grey = '#6b8d94'
                    local green = '#8dac8b'
                    local yellow = '#F4AE59'
                    local red = '#c27166'
                    local cyan = '#93bfc2'
                    vim.api.nvim_set_hl(0, 'CursorLine', { bg = bg_alt })
                    vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = bg_alt, fg = yellow })
                    vim.api.nvim_set_hl(0, 'LineNr', { fg = grey })
                    vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NONE', fg = grey })
                    vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { bg = 'NONE', fg = green })
                    vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', { bg = 'NONE', fg = '#ed9366' })
                    vim.api.nvim_set_hl(0, 'MiniStatuslineFileinfo', { bg = 'NONE', fg = green })
                    vim.api.nvim_set_hl(0, 'NeoTreeStatusLine', { bg = 'NONE', fg = 'NONE' })
                    vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'NONE', fg = 'NONE' })
                    vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { bg = yellow, fg = bg_dark, bold = true })
                    vim.api.nvim_set_hl(0, 'BufferTabpageFill', { bg = bg_alt })
                    vim.api.nvim_set_hl(0, 'BufferInactive', { bg = bg_alt, fg = grey })
                    vim.api.nvim_set_hl(0, 'BufferInactiveIndex', { bg = bg_alt, fg = grey })
                    vim.api.nvim_set_hl(0, 'BufferInactiveMod', { bg = bg_alt, fg = grey })
                    vim.api.nvim_set_hl(0, 'BufferInactiveSign', { bg = bg_alt, fg = grey })
                    vim.api.nvim_set_hl(0, 'BufferInactiveIcon', { bg = bg_alt })
                    vim.api.nvim_set_hl(0, 'BufferInactiveTarget', { bg = bg_alt, fg = grey })
                    vim.api.nvim_set_hl(0, 'BufferCurrent', { bg = bg_alt, fg = yellow })
                    vim.api.nvim_set_hl(0, 'BufferCurrentIndex', { bg = bg_alt, fg = yellow })
                    vim.api.nvim_set_hl(0, 'BufferCurrentMod', { bg = bg_alt, fg = yellow })
                    vim.api.nvim_set_hl(0, 'BufferCurrentSign', { bg = bg_alt, fg = yellow })
                    vim.api.nvim_set_hl(0, 'BufferCurrentIcon', { bg = bg_alt })
                    vim.api.nvim_set_hl(0, 'BufferCurrentTarget', { bg = bg_alt, fg = red })
                else
                    -- Light theme (pencil-light colors)
                    vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#eeeeee', fg = '#424242' })
                    vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { bg = '#eeeeee', fg = '#10a778' })
                    vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', { bg = '#eeeeee', fg = '#424242' })
                    vim.api.nvim_set_hl(0, 'MiniStatuslineFileinfo', { bg = '#eeeeee', fg = '#10a778' })
                    vim.api.nvim_set_hl(0, 'NeoTreeStatusLine', { bg = '#eeeeee', fg = '#eeeeee' })
                    vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = '#eeeeee', fg = '#eeeeee' })
                    vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { bg = '#10a778', fg = '#eeeeee', bold = true })
                    vim.api.nvim_set_hl(0, 'BufferTabpageFill', { bg = '#e0e0e0' })
                    vim.api.nvim_set_hl(0, 'BufferInactive', { bg = '#e0e0e0', fg = '#888888' })
                    vim.api.nvim_set_hl(0, 'BufferInactiveIndex', { bg = '#e0e0e0', fg = '#888888' })
                    vim.api.nvim_set_hl(0, 'BufferInactiveMod', { bg = '#e0e0e0', fg = '#888888' })
                    vim.api.nvim_set_hl(0, 'BufferInactiveSign', { bg = '#e0e0e0', fg = '#888888' })
                    vim.api.nvim_set_hl(0, 'BufferInactiveIcon', { bg = '#e0e0e0' })
                    vim.api.nvim_set_hl(0, 'BufferInactiveTarget', { bg = '#e0e0e0', fg = '#888888' })
                    vim.api.nvim_set_hl(0, 'BufferCurrent', { bg = '#e0e0e0', fg = '#424242' })
                    vim.api.nvim_set_hl(0, 'BufferCurrentIndex', { bg = '#e0e0e0', fg = '#424242' })
                    vim.api.nvim_set_hl(0, 'BufferCurrentMod', { bg = '#e0e0e0', fg = '#424242' })
                    vim.api.nvim_set_hl(0, 'BufferCurrentSign', { bg = '#e0e0e0', fg = '#10a778' })
                    vim.api.nvim_set_hl(0, 'BufferCurrentIcon', { bg = '#e0e0e0' })
                    vim.api.nvim_set_hl(0, 'BufferCurrentTarget', { bg = '#e0e0e0', fg = '#d75f5f' })
                    vim.api.nvim_set_hl(0, 'SidekickChat', { bg = '#eeeeee', fg = '#424242' })
                    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#eeeeee', fg = '#424242' })
                    vim.api.nvim_set_hl(0, 'BufferVisible', { bg = '#e0e0e0', fg = '#666666' })
                    vim.api.nvim_set_hl(0, 'BufferVisibleIndex', { bg = '#e0e0e0', fg = '#666666' })
                    vim.api.nvim_set_hl(0, 'BufferVisibleMod', { bg = '#e0e0e0', fg = '#666666' })
                    vim.api.nvim_set_hl(0, 'BufferVisibleSign', { bg = '#e0e0e0', fg = '#666666' })
                    vim.api.nvim_set_hl(0, 'BufferVisibleIcon', { bg = '#e0e0e0' })
                    vim.api.nvim_set_hl(0, 'BufferVisibleTarget', { bg = '#e0e0e0', fg = '#d75f5f' })
                    vim.api.nvim_set_hl(0, 'MiniStatuslineInactive', { bg = '#eeeeee', fg = '#888888' })
                    vim.api.nvim_set_hl(0, 'StatusLineTerm', { bg = '#eeeeee', fg = '#424242' })
                    vim.api.nvim_set_hl(0, 'StatusLineTermNC', { bg = '#eeeeee', fg = '#888888' })
                    vim.api.nvim_set_hl(0, 'Terminal', { bg = '#eeeeee', fg = '#424242' })
                    vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { bg = '#eeeeee', fg = '#888888' })
                end
            end
            local function apply_markdown_highlights()
                if vim.o.background == 'dark' then
                    vim.api.nvim_set_hl(0, 'RenderMarkdownCode', { bg = 'NONE' })
                    vim.api.nvim_set_hl(0, 'RenderMarkdownCodeInline', { bg = 'NONE' })
                    for i = 1, 6 do
                        vim.api.nvim_set_hl(0, 'RenderMarkdownH' .. i .. 'Bg', { bg = 'NONE' })
                    end
                end
            end
            apply_custom_highlights()
            vim.api.nvim_create_autocmd('ColorScheme', { callback = apply_custom_highlights })
            vim.api.nvim_create_autocmd('FileType', { pattern = 'markdown', callback = apply_markdown_highlights })
            vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
                callback = function()
                    if vim.bo.filetype == 'neo-tree' then
                        vim.wo.statusline = ' '
                    end
                end,
            })
        end,
        keys = {
            { '<leader>n', '<cmd>Neotree toggle<cr>', desc = 'Neo-tree toggle' },
            { '<leader>e', '<cmd>Neotree reveal<cr>', desc = 'Neo-tree reveal file' },
        },
    },

    -- LSP file operations (auto-update imports on rename)
    {
        'antosha417/nvim-lsp-file-operations',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-neo-tree/neo-tree.nvim',
        },
        config = function()
            require('lsp-file-operations').setup()
        end,
    },

    -- Git signs (показывает изменения + blame)
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {
                current_line_blame = true,
                current_line_blame_opts = {
                    delay = 300,
                },
            }
            -- Set highlight after gitsigns loads
            if vim.o.background == 'light' then
                vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { fg = '#888888', default = false })
            end
        end,
    },

    -- Diffview (git diff viewer)
    {
        'sindrets/diffview.nvim',
        opts = {
            view = {
                merge_tool = {
                    layout = 'diff3_mixed',
                },
            },
        },
        keys = {
            { '<leader>do', '<cmd>DiffviewOpen<cr>', desc = 'Diff open' },
            { '<leader>dh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diff file history' },
            { '<leader>dc', '<cmd>DiffviewClose<cr>', desc = 'Diff close' },
        },
    },

    -- Window picker for neo-tree
    {
        's1n7ax/nvim-window-picker',
        version = '2.*',
        config = function()
            require('window-picker').setup {
                filter_rules = {
                    include_current_win = false,
                    autoselect_one = true,
                    bo = {
                        filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
                        buftype = { 'terminal', 'quickfix' },
                    },
                },
            }
        end,
    },

    -- Oil (file manager)
    {
        'stevearc/oil.nvim',
        opts = {
            default_file_explorer = true,
            columns = { 'icon' },
            keymaps = {
                ['g?'] = 'actions.show_help',
                ['<CR>'] = 'actions.select',
                ['<C-s>'] = 'actions.select_vsplit',
                ['<C-h>'] = 'actions.select_split',
                ['<C-t>'] = 'actions.select_tab',
                ['<C-p>'] = 'actions.preview',
                ['<C-c>'] = 'actions.close',
                ['<C-l>'] = 'actions.refresh',
                ['-'] = 'actions.parent',
                ['_'] = 'actions.open_cwd',
                ['`'] = 'actions.cd',
                ['~'] = 'actions.tcd',
                ['gs'] = 'actions.change_sort',
                ['gx'] = 'actions.open_external',
                ['g.'] = 'actions.toggle_hidden',
            },
            view_options = {
                show_hidden = false,
            },
        },
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        keys = {
            { '<leader>o', '<cmd>Oil<CR>', desc = 'Oil' },
        },
    },

    -- Barbar (табы/буферы)
    {
        'romgrk/barbar.nvim',
        lazy = false,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        init = function()
            vim.g.barbar_auto_setup = false
        end,
        opts = {
            focus_on_close = 'left',
            sidebar_filetypes = {
                ['neo-tree'] = { event = 'BufWinLeave' },
            },
            auto_hide = false,
            icons = {
                inactive = { separator = { left = '', right = '' } },
            },
        },
        keys = {
            { '<leader>bo', '<cmd>BufferCloseAllButCurrent<cr>', desc = 'Close other buffers' },
            { '<leader>bc', '<cmd>BufferClose<cr>', desc = 'Close buffer' },
        },
    },

    -- Fetchfact for dashboard footer
    {
        'notelgnis/fetchfact.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            cache_file_path = '~/.cache/facts_cache.json',
            config_file_path = '~/.config/.facts_api_key',
            min_facts = 2,
            max_facts = 10,
        },
    },

    -- Dashboard
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            require('dashboard').setup {
                theme = 'hyper',
                config = {
                    packages = {},
                    shortcut = {},
                    header = {

                        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
                        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⣰⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⢲⡄⠀',
                        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠀⠀⠀⠠⣶⣦⢀⠀⠀⠀⠀⠀⢠⠁⠀⠀⢀⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀',
                        '⠠⣤⠀⠀⠀⠀⠀⠀⠀⣜⠀⠀⠀⠀⠀⠉⠫⣿⣗⣤⡀⠀⠀⠇⣀⠀⠠⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀󱇽⠆ ⡇',
                        '⠀⠈⠻▒⣦⣄⠀⠀⡼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⣷⣾⡝⠀⣿⠀⠀⠀⣷⠀⠀⠀⠀⠀⠀⠀⠀  ⠇',
                        '⠀⠀⠀⠀⠁⠹░⡟⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀░⠇⠀⢸⡃⠀⠀⣼▒⠀⠀⠀⠀⠀⠀󱇽⣦⠀⣼⠀',
                        '⠀⠀⠀⠀⠀⠀⠀⠈⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰▒⡿⠀⠀⠀⢻⠀⣾▒⣆⠀⠀⠀⠀⠀⠀⠀⣼⠀⠀',
                        '⠀⠀⠀⠀⠀⠀⠠⣾▒⠈⠻⣇⡤⡀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠁⠀⠀⠀⠀⡿▒⠁⠐▒⠇⠀⠀⠀⠀ ⢀⠀⠀⠀',
                        '⠀⠀⠀⠀⠀⠀⣾▒⠀⠀⠀⠈⢿░⡦⡀⠀⠀⠀⠀⢠⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⠋⠀⠀⠀⠀',
                        '⠀⠀⠀⠀⠀⡾▒⠁⠀⠀⠀⠀⠀⠀⠀⠙░⣧⣀⠀⠀⡧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
                        '⠀⠀⠀⠀⣼⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑░░⣦⡈⠹⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
                        '⠀⠀⠀⠰⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠫⡉⠀⠀ ⠀ Yep, exactly that. ',
                        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⢧⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
                        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
                        '',
                    },
                    footer = function()
                        local ok, fact = pcall(function()
                            return require('fetchfact').get_split_fact(85)
                        end)
                        if ok and fact then
                            return { '', unpack(fact) }
                        end
                        return { '', 'Ready to code!' }
                    end,
                },
            }
        end,
        dependencies = {
            { 'nvim-tree/nvim-web-devicons' },
        },
    },

    -- omnisharp-extended для декомпиляции C#
    {
        'Hoffs/omnisharp-extended-lsp.nvim',
        lazy = false,
    },

    -- Database UI (PostgreSQL, MySQL, SQLite, MSSQL, etc.)
    {
        'kndndrj/nvim-dbee',
        dependencies = { 'MunifTanjim/nui.nvim' },
        build = function()
            require('dbee').install()
        end,
        config = function()
            require('dbee').setup {
                sources = {
                    require('dbee.sources').FileSource:new(vim.fn.stdpath 'state' .. '/dbee/connections.json'),
                },
                window_layout = require('dbee.layouts').Default:new({
                    drawer_width = 50,
                    result_height = 15,
                }),
                editor = {
                    mappings = {
                        { key = '<F5>', mode = 'v', action = 'run_selection' },
                        { key = '<F5>', mode = 'n', action = 'run_file' },
                    },
                },
            }
        end,
        keys = {
            {
                '<leader>db',
                function()
                    require('dbee').toggle()
                end,
                desc = 'Toggle Dbee',
            },
        },
    },

    -- Mason (для установки LSP серверов)
    {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup()
        end,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            require('mason-lspconfig').setup {
                ensure_installed = {
                    'lua_ls',
                    -- 'sqls', -- установлен вручную через go install
                    'omnisharp',
                    'ts_ls',
                    'jsonls',
                    'lemminx',
                    'marksman',
                    'intelephense',
                },
            }
        end,
    },

    -- Colorizer (показывает цвета в коде)
    {
        'NvChad/nvim-colorizer.lua',
        event = 'BufReadPost',
        opts = {
            user_default_options = {
                RGB = true,
                RRGGBB = true,
                names = false,
                RRGGBBAA = true,
                rgb_fn = true,
                hsl_fn = true,
                css = true,
                css_fn = true,
                mode = 'virtualtext',
                virtualtext = '■',
                virtualtext_inline = true,
            },
        },
    },

    -- Render markdown с поддержкой mermaid
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        ft = { 'markdown' },
        opts = {},
    },

    -- HTTP client (REST API requests from .http files)
    {
        'mistweaverco/kulala.nvim',
        ft = { 'http' },
        opts = {
            icons = {
                inlay = {
                    loading = '󰔟',
                    done = '✓',
                    error = '✗',
                },
                errorHighlight = 'DiagnosticError',
                doneHighlight = 'DiagnosticOk',
            },
        },
        keys = {
            {
                '<leader>hr',
                function()
                    require('kulala').run()
                end,
                desc = 'HTTP run request',
                ft = 'http',
            },
            {
                '<leader>ha',
                function()
                    require('kulala').run_all()
                end,
                desc = 'HTTP run all',
                ft = 'http',
            },
            {
                '<leader>hp',
                function()
                    require('kulala').jump_prev()
                end,
                desc = 'HTTP prev request',
                ft = 'http',
            },
            {
                '<leader>hn',
                function()
                    require('kulala').jump_next()
                end,
                desc = 'HTTP next request',
                ft = 'http',
            },
        },
    },

    -- Image viewer (для Ghostty/Kitty)
    {
        'folke/snacks.nvim',
        priority = 1000,
        opts = {
            image = { enabled = true },
        },
    },

    -- Fast Fuzzy File finder
    {
        'dmtrKovalenko/fff.nvim',
        build = function()
            require('fff.download').download_or_build_binary()
        end,
        lazy = false,
        keys = {
            {
                'ff',
                function()
                    require('fff').find_files()
                end,
                desc = 'Find files (fff)',
            },
        },
    },

    -- Markdown preview в браузере (с mermaid)
    {
        'iamcco/markdown-preview.nvim',
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        ft = { 'markdown' },
        build = 'cd app && npm install && git checkout -- yarn.lock',
        keys = {
            { '<leader>mp', '<cmd>MarkdownPreviewToggle<CR>', desc = '[M]arkdown [P]preview' },
        },
    },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
        },
        config = function()
            require('telescope').setup {}
            pcall(require('telescope').load_extension, 'fzf')

            local builtin = require 'telescope.builtin'
            vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch [B]uffers' })
            vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sr', builtin.oldfiles, { desc = '[S]earch [R]ecent' })
            vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Find buffers' })
        end,
    },

    -- Which-key (подсказки клавиш)
    {
        'folke/which-key.nvim',
        event = 'VimEnter',
        config = function()
            require('which-key').setup()
            require('which-key').add {
                { '<leader>s', group = '[S]earch' },
                { '<leader>c', group = '[C]ode' },
                { '<leader>r', group = '[R]ename' },
            }
        end,
    },

    -- Todo-comments (подсветка TODO/FIXME/NOTE)
    {
        'folke/todo-comments.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { signs = false },
    },

    -- Conform (автоформатирование)
    {
        'stevearc/conform.nvim',
        event = 'BufWritePre',
        cmd = { 'ConformInfo' },
        keys = {
            {
                '<leader>f',
                function()
                    require('conform').format { async = true, lsp_fallback = true }
                end,
                desc = '[F]ormat buffer',
            },
        },
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                local ft = vim.bo[bufnr].filetype
                if ft == 'sql' or ft == 'mysql' or ft == 'plsql' then
                    return false
                end
                return { timeout_ms = 500, lsp_fallback = true }
            end,
            formatters_by_ft = {
                lua = { 'stylua' },
                javascript = { 'prettier' },
                typescript = { 'prettier' },
                json = { 'prettier' },
                markdown = { 'prettier' },
                sql = {},  -- отключить форматирование для SQL
            },
        },
    },

    -- Auto Session (save/restore buffers, windows, etc.)
    {
        'rmagatti/auto-session',
        lazy = false,
        opts = {
            suppressed_dirs = { '~/', '~/Downloads', '~/Desktop', '/' },
            pre_save_cmds = {
                function()
                    pcall(vim.cmd, 'Neotree close')
                end,
            },
            post_restore_cmds = {
                function()
                    vim.defer_fn(function()
                        pcall(vim.cmd, 'Neotree show')
                    end, 50)
                end,
            },
        },
        keys = {
            { '<leader>ss', '<cmd>SessionSave<cr>', desc = 'Save session' },
            { '<leader>sr', '<cmd>SessionRestore<cr>', desc = 'Restore session' },
            { '<leader>sd', '<cmd>SessionDelete<cr>', desc = 'Delete session' },
        },
    },

    -- GitHub Copilot
    {
        'github/copilot.vim',
        lazy = false,
    },

    -- Claude Code integration (WebSocket MCP)
    {
        'coder/claudecode.nvim',
        dependencies = { 'folke/snacks.nvim' },
        lazy = false,
        config = true,
        keys = {
            { '<leader>a', nil, desc = 'AI/Claude Code' },
            { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
            { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
            { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
            { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
            { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
            { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
            { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
            {
                '<leader>as',
                '<cmd>ClaudeCodeTreeAdd<cr>',
                desc = 'Add file',
                ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw', 'nerdtree' },
            },
            { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
            { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
        },
    },

    -- Blink.cmp (автокомплит)
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        version = '*',
        opts = {
            keymap = {
                preset = 'default',
                ['<CR>'] = { 'accept', 'fallback' },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono',
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            completion = {
                accept = { auto_brackets = { enabled = false } },
            },
        },
    },

    -- Indent guides (rainbow)
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        config = function()
            local highlight = {
                'RainbowRed',
                'RainbowYellow',
                'RainbowBlue',
                'RainbowOrange',
                'RainbowGreen',
                'RainbowViolet',
                'RainbowCyan',
            }

            local hooks = require 'ibl.hooks'
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                if vim.o.background == 'dark' then
                    -- Muted colors for dark theme
                    vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#5c3a3d' })
                    vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#5c5340' })
                    vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#3a4d5c' })
                    vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#5c4a3a' })
                    vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#3d5c3a' })
                    vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#4d3a5c' })
                    vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#3a5c5c' })
                else
                    -- Bright colors for light theme
                    vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
                    vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
                    vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
                    vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
                    vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
                    vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
                    vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
                end
            end)

            require('ibl').setup {
                exclude = { filetypes = { 'dashboard' } },
                indent = {
                    char = '┊',
                    highlight = highlight,
                },
            }
        end,
    },

    -- Treesitter (подсветка синтаксиса)
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = {
                    'lua',
                    'sql',
                    'c_sharp',
                    'php',
                    'javascript',
                    'typescript',
                    'json',
                    'xml',
                    'markdown',
                    'markdown_inline',
                    'mermaid',
                    'html',
                    'css',
                    'scss',
                    'yaml',
                    'bash',
                    'dockerfile',
                    'vim',
                    'vimdoc',
                },
                auto_install = true,
                highlight = {
                    enable = true,
                    disable = { 'dockerfile' },
                    additional_vim_regex_highlighting = { 'dockerfile' },
                },
                indent = { enable = true },
            }
        end,
    },

    -- Mini.nvim (statusline + indentscope)
    {
        'echasnovski/mini.nvim',
        config = function()
            local statusline = require 'mini.statusline'
            statusline.setup { use_icons = vim.g.have_nerd_font }
            statusline.section_location = function()
                return '%2l:%-2v'
            end

            require('mini.comment').setup()
            require('mini.surround').setup()
            require('mini.pairs').setup()
            require('mini.jump').setup()
            require('mini.splitjoin').setup()
        end,
    },
}, {
    ui = {
        icons = vim.g.have_nerd_font and {} or {
            cmd = '⌘',
            config = '🛠',
            event = '📅',
            ft = '📂',
            init = '⚙',
            keys = '🗝',
            plugin = '🔌',
            runtime = '💻',
            require = '🌙',
            source = '📄',
            start = '🚀',
            task = '📌',
            lazy = '💤 ',
        },
    },
})

-- OmniSharp для C# (после lazy.setup чтобы omnisharp_extended был доступен)
vim.lsp.config('omnisharp', {
    cmd = { vim.fn.stdpath 'data' .. '/mason/bin/OmniSharp', '--languageserver' },
    filetypes = { 'cs' },
    root_markers = { '.git' },
    handlers = {
        ['textDocument/definition'] = require('omnisharp_extended').definition_handler,
        ['textDocument/typeDefinition'] = require('omnisharp_extended').type_definition_handler,
        ['textDocument/references'] = require('omnisharp_extended').references_handler,
        ['textDocument/implementation'] = require('omnisharp_extended').implementation_handler,
    },
})
vim.lsp.enable 'omnisharp'

-- gd для C# с декомпиляцией через omnisharp-extended
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.name == 'omnisharp' then
            vim.keymap.set('n', 'gd', function()
                require('omnisharp_extended').lsp_definition()
            end, { buffer = event.buf, desc = 'LSP: Go to Definition (C#)' })
            vim.keymap.set('n', 'gr', function()
                require('omnisharp_extended').lsp_references()
            end, { buffer = event.buf, desc = 'LSP: References (C#)' })
            vim.keymap.set('n', 'gI', function()
                require('omnisharp_extended').lsp_implementation()
            end, { buffer = event.buf, desc = 'LSP: Implementation (C#)' })
        end
    end,
})
