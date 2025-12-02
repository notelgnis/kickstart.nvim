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
vim.opt.guicursor = 'n-v-c:block-Cursor,i-ci-ve:ver50-iCursor,r-cr:hor20,o:hor50'

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
        -- Cursor visibility for light theme
        vim.cmd [[hi Cursor guifg=#ffffff guibg=#005f87]]
        vim.cmd [[hi iCursor guifg=#ffffff guibg=#ff0000]]
        vim.cmd [[hi CursorIM guifg=#ffffff guibg=#af0000]]
    end
end

vim.keymap.set('n', '<leader>l', function()
    if vim.o.background == 'dark' then
        vim.o.background = 'light'
        vim.cmd 'colorscheme PaperColor'
    else
        vim.o.background = 'dark'
        require('ayu').colorscheme()
        vim.api.nvim_set_hl(0, 'WinSeparator', { bg = '#1a1a1a' })
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
                vim.api.nvim_set_hl(0, 'WinSeparator', { bg = '#1a1a1a' })
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
    -- Ayu тема (dark)
    {
        'Shatur/neovim-ayu',
        priority = 1000,
        config = function()
            require('ayu').setup {
                mirage = false, -- false = dark, true = mirage
                terminal = true,
                overrides = {
                    Normal = { bg = '#1a1a1a' },
                    NormalFloat = { bg = '#1a1a1a' },
                    SignColumn = { bg = '#1a1a1a' },
                    NvimTreeNormal = { bg = '#1a1a1a' },
                    LineNr = { fg = '#626A73' }, -- неактивные номера строк
                },
            }
            -- Apply theme based on system preference
            if vim.g.system_theme_is_dark then
                require('ayu').colorscheme()
            else
                vim.o.background = 'light'
                vim.cmd 'colorscheme PaperColor'
            end
        end,
    },

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
                            deleted = '✖',
                            modified = '',
                            renamed = '󰑕',
                            untracked = '',
                            ignored = '',
                            unstaged = '',
                            staged = '',
                            conflict = '',
                        },
                    },
                },
            }
            -- Custom folder colors (red icons, orange names for dark theme)
            local function apply_neotree_colors()
                local is_dark = vim.o.background == 'dark'
                local folder_icon = is_dark and '#CC3333' or '#af0000'
                local folder_name = is_dark and '#FFB454' or '#005f87'
                vim.api.nvim_set_hl(0, 'NeoTreeDirectoryIcon', { fg = folder_icon })
                vim.api.nvim_set_hl(0, 'NeoTreeDirectoryName', { fg = folder_name })
                vim.api.nvim_set_hl(0, 'NeoTreeGitModified', { fg = folder_name, italic = true })
                vim.api.nvim_set_hl(0, 'NeoTreeGitUntracked', { fg = folder_name, italic = true })
                -- Diffview folder colors (same as neo-tree)
                vim.api.nvim_set_hl(0, 'DiffviewFolderSign', { fg = folder_icon })
                vim.api.nvim_set_hl(0, 'DiffviewFolderName', { fg = folder_name })
            end
            apply_neotree_colors()
            vim.api.nvim_create_autocmd('ColorScheme', { callback = apply_neotree_colors })
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
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },

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

    -- Image viewer (для Ghostty/Kitty)
    {
        'folke/snacks.nvim',
        opts = {
            image = { enabled = true },
        },
    },

    -- Markdown preview в браузере (с mermaid)
    {
        'iamcco/markdown-preview.nvim',
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        ft = { 'markdown' },
        build = 'cd app && npm install',
        keys = {
            { '<leader>mp', '<cmd>MarkdownPreviewToggle<CR>', desc = '[M]arkdown [P]review' },
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
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
            formatters_by_ft = {
                lua = { 'stylua' },
                javascript = { 'prettier' },
                typescript = { 'prettier' },
                json = { 'prettier' },
                markdown = { 'prettier' },
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

    -- Mini.nvim (только statusline)
    {
        'echasnovski/mini.nvim',
        config = function()
            local statusline = require 'mini.statusline'
            statusline.setup { use_icons = vim.g.have_nerd_font }
            statusline.section_location = function()
                return '%2l:%-2v'
            end
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
