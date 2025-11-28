-- Minimal Neovim config: Dashboard + NERDTree + Statusline

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd Font
vim.g.have_nerd_font = true

-- Folder icons for vim-devicons (Windows disables by default)
vim.g.DevIconsEnableFoldersOpenClose = 1

-- NERDTree folder icons (Windows uses +/~ by default)
if vim.fn.has('win32') == 1 then
    vim.g.NERDTreeDirArrowExpandable = '\u{e5ff}'
    vim.g.NERDTreeDirArrowCollapsible = '\u{e5fe}'
end

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
    else
        vim.cmd [[hi CursorLineNr ctermfg=27  ctermbg=NONE]]
    end
    vim.cmd [[hi DashboardHeader ctermfg=14]]
    vim.cmd [[hi DashboardFooter ctermfg=12]]
end

vim.keymap.set('n', '<leader>l', function()
    vim.o.background = (vim.o.background == 'dark') and 'light' or 'dark'
    apply_cterm_highlights()
end, { desc = 'Toggle Dark/Light' })

-- NERDTree toggle
local nerdTreeToggle = function()
    vim.cmd [[NERDTreeToggle]]
    vim.cmd [[hi NonText guifg=bg]]
end
vim.keymap.set('n', '<leader>n', nerdTreeToggle, { desc = '[N]ERDTree Toggle' })

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- VimEnter setup
vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
        vim.defer_fn(function()
            apply_cterm_highlights()
            vim.opt.fillchars = { vert = ' ', eob = ' ' }
        end, 1)
    end,
})

-- Добавляем Mason bin в PATH
vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin:' .. vim.env.PATH

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

-- Enable LSP servers (omnisharp включается отдельно после lazy.setup)
vim.lsp.enable({ 'lua_ls', 'sqls', 'ts_ls', 'jsonls', 'lemminx', 'marksman' })

-- [[ Lazy.nvim plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Plugins ]]
require('lazy').setup({
    -- Ayu тема с прозрачностью
    {
        'Shatur/neovim-ayu',
        priority = 1000,
        config = function()
            require('ayu').setup({
                mirage = false, -- false = dark, true = mirage
                terminal = true,
                overrides = {
                    Normal = { bg = 'NONE' },
                    NormalFloat = { bg = 'NONE' },
                    SignColumn = { bg = 'NONE' },
                    NvimTreeNormal = { bg = 'NONE' },
                    LineNr = { fg = '#626A73' },  -- неактивные номера строк
                },
            })
            require('ayu').colorscheme()
        end,
    },

    -- NERDTree
    {
        'notelgnis/nerdtree',
        lazy = false,
        config = function()
            vim.cmd [[autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\]" contained conceal containedin=ALL]]
            vim.cmd [[autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\[" contained conceal containedin=ALL]]
            vim.cmd [[autocmd FileType nerdtree syntax match NERDTreeDirSlash #/$# containedin=NERDTreeDir conceal contained]]
            vim.cmd [[set fillchars+=vert:\ ]]
            -- Цвет папок (Ayu orange)
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'nerdtree',
                callback = function()
                    vim.api.nvim_set_hl(0, 'NERDTreeFolderClosedIconHighlight', { fg = '#FFB454' })
                    vim.api.nvim_set_hl(0, 'NERDTreeFolderOpendIconHighlight', { fg = '#FFB454' })
                end,
            })
        end,
    },

    -- Devicons for NERDTree
    {
        'ryanoasis/vim-devicons',
        dependencies = { 'notelgnis/nerdtree' },
        config = function()
            if vim.fn.has('win32') == 1 then
                vim.g.WebDevIconsUnicodeDecorateFileNodesExtensionSymbols =
                    vim.tbl_extend('force', vim.g.WebDevIconsUnicodeDecorateFileNodesExtensionSymbols or {}, {
                        cs = '\u{e648}'
                    })
                vim.cmd([[autocmd FileType nerdtree syn match NERDTreeCSharpIconHighlight '\u{e648}' containedin=ALL]])
            end
        end,
    },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },

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
                nerdtree = { event = 'BufWinLeave' },
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
                        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠀⠀⠀⠠⣶⣦⢀⠀⠀⠀⠀⠀⢠⠁⠀⠀⢀⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀',
                        '⠠⣤⠀⠀⠀⠀⠀⠀⠀⣜⠀⠀⠀⠀⠀⠉⠫⣿⣗⣤⡀⠀⠀⠇⣀⠀⠠⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀󱇽⠆⡇ ',
                        '⠀⠈⠻▒⣦⣄⠀⠀⡼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⣷⣾⡝⠀⣿⠀⠀⠀⣷⠀⠀⠀⠀⠀⠀⠀⠀ ⠇ ',
                        '⠀⠀⠀⠀⠁⠹░⡟⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀░⠇⠀⢸⡃⠀⠀⣼▒⠀⠀⠀⠀⠀⠀󱇽⣦⠀⣼⠀',
                        '⠀⠀⠀⠀⠀⠀⠀⠈⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰▒⡿⠀⠀⠀⢻⠀⣾▒⣆⠀⠀⠀⠀⠀⠀⠀⣼⠀⠀',
                        '⠀⠀⠀⠀⠀⠀⠠⣾▒⠈⠻⣇⡤⡀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠁⠀⠀⠀⠀⡿▒⠁⠐▒⠇⠀⠀⠀⠀ ⢀⠀⠀⠀',
                        '⠀⠀⠀⠀⠀⠀⣾▒⠀⠀⠀⠈⢿░⡦⡀⠀⠀⠀⠀⢠⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⠋⠀⠀⠀⠀',
                        '⠀⠀⠀⠀⠀⡾▒⠁⠀⠀⠀⠀⠀⠀⠀⠙░⣧⣀⠀⠀⡧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
                        '⠀⠀⠀⠀⣼⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑░░⣦⡈⠹⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
                        '⠀⠀⠀⠰⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠫⡉⠀⠀ ⠀ Yep, exactly that. ',
                        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⢧⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
                        '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
                        '',
                    },
                    footer = function()
                        local fact = require('fetchfact').get_split_fact(85)
                        return { '', unpack(fact) }
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
                },
            }
        end,
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

    -- Blink.cmp (автокомплит)
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        version = '*',
        opts = {
            keymap = { preset = 'default' },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono',
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
        },
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
                    'javascript',
                    'typescript',
                    'json',
                    'xml',
                    'markdown',
                    'markdown_inline',
                    'html',
                    'css',
                    'yaml',
                    'bash',
                    'dockerfile',
                    'vim',
                    'vimdoc',
                },
                auto_install = true,
                highlight = { enable = true },
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
    cmd = { vim.fn.stdpath('data') .. '/mason/bin/OmniSharp', '--languageserver' },
    filetypes = { 'cs' },
    root_markers = { '.git' },
    handlers = {
        ['textDocument/definition'] = require('omnisharp_extended').definition_handler,
        ['textDocument/typeDefinition'] = require('omnisharp_extended').type_definition_handler,
        ['textDocument/references'] = require('omnisharp_extended').references_handler,
        ['textDocument/implementation'] = require('omnisharp_extended').implementation_handler,
    },
})
vim.lsp.enable('omnisharp')

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
