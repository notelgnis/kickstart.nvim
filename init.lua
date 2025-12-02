-- Minimal Neovim config: Dashboard + NERDTree + Statusline

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd Font
vim.g.have_nerd_font = true

-- Folder icons for vim-devicons (Windows disables by default)
vim.g.DevIconsEnableFoldersOpenClose = 1

-- Override icons in vim-devicons to match nvim-web-devicons
vim.g.WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {
    cs = '󰌛', -- C#
    http = '󰖟', -- HTTP requests
}
vim.g.WebDevIconsUnicodeDecorateFileNodesExactSymbols = {
    ['Dockerfile'] = '󰡨',
    ['dockerfile'] = '󰡨',
    ['docker-compose.yml'] = '󰡨',
    ['docker-compose.yaml'] = '󰡨',
}

-- Reduce spacing between icon and filename in NERDTree
vim.g.WebDevIconsNerdTreeAfterGlyphPadding = ''

-- NERDTree folder icons (Windows uses +/~ by default)
if vim.fn.has 'win32' == 1 then
    vim.g.NERDTreeDirArrowExpandable = '\u{e5ff}'
    vim.g.NERDTreeDirArrowCollapsible = '\u{e5fe}'
end

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

-- Restore all NERDTree icon highlights after theme change
local function apply_nerdtree_highlights()
    local is_dark = vim.o.background == 'dark'
    -- Folder icons (different colors for dark/light)
    local folder_color = is_dark and '#CC3333' or '#af0000'
    vim.api.nvim_set_hl(0, 'NERDTreeFolderClosedIconHighlight', { fg = folder_color })
    vim.api.nvim_set_hl(0, 'NERDTreeFolderOpendIconHighlight', { fg = folder_color })
    -- All other icon highlights from nerdtree.vim
    vim.api.nvim_set_hl(0, 'NERDTreeCSharpIconHighlight', { fg = '#206040' })
    vim.api.nvim_set_hl(0, 'NERDTreeArrowClosedIconHighlight', { fg = '#b3b3b3' })
    vim.api.nvim_set_hl(0, 'NERDTreeArrowOpenedIconHighlight', { fg = '#b3b3b3' })
    vim.api.nvim_set_hl(0, 'NERDTreeYamlIconHighlight', { fg = '#2e5cb8' })
    vim.api.nvim_set_hl(0, 'NERDTreeLicenseIconHighlight', { fg = '#ffcc00' })
    vim.api.nvim_set_hl(0, 'NERDTreeSolutionIconHighlight', { fg = '#6600cc' })
    vim.api.nvim_set_hl(0, 'NERDTreeGeneralIconHighlight', { fg = '#666666' })
    vim.api.nvim_set_hl(0, 'NERDTreePicIconHighlight', { fg = '#336699' })
    vim.api.nvim_set_hl(0, 'NERDTreeJsonIconHighlight', { fg = is_dark and '#ccff33' or '#7a9900' })
    vim.api.nvim_set_hl(0, 'NERDTreeMdIconHighlight', { fg = '#669999' })
    vim.api.nvim_set_hl(0, 'NERDTreePrjIconHighlight', { fg = '#b366ff' })
    vim.api.nvim_set_hl(0, 'NERDTreeLuaIconHighlight', { fg = '#9999ff' })
    vim.api.nvim_set_hl(0, 'NERDTreeXmlIconHighlight', { fg = '#00ccff' })
    vim.api.nvim_set_hl(0, 'NERDTreeDockerIconHighlight', { fg = '#458EE6' })
    vim.api.nvim_set_hl(0, 'NERDTreeHttpIconHighlight', { fg = '#008EC7' })
    -- Folder names
    if is_dark then
        vim.api.nvim_set_hl(0, 'NERDTreeDir', { fg = '#FFB454' })
        vim.api.nvim_set_hl(0, 'Directory', { fg = '#FFB454' })
    else
        vim.api.nvim_set_hl(0, 'NERDTreeDir', { fg = '#005f87' })
        vim.api.nvim_set_hl(0, 'Directory', { fg = '#005f87' })
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
    -- Refresh NERDTree syntax first
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].filetype == 'nerdtree' then
            vim.api.nvim_buf_call(buf, function()
                vim.cmd 'syntax clear'
                vim.cmd 'runtime syntax/nerdtree.vim'
            end)
        end
    end
    -- Then apply our custom highlights on top
    apply_nerdtree_highlights()
    -- Refresh barbar highlights
    vim.cmd 'doautocmd ColorScheme'
end, { desc = 'Toggle Dark/Light' })

-- NERDTree toggle
local nerdTreeToggle = function()
    vim.cmd [[NERDTreeToggle]]
    vim.cmd [[hi NonText guifg=bg]]
    apply_nerdtree_highlights()
end
vim.keymap.set('n', '<leader>n', nerdTreeToggle, { desc = '[N]ERDTree Toggle' })

-- Apply highlights when NERDTree opens
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'nerdtree',
    callback = function()
        vim.defer_fn(apply_nerdtree_highlights, 10)
    end,
})

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
            apply_nerdtree_highlights()
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

    -- NERDTree
    {
        'notelgnis/nerdtree',
        branch = 'custom-tweaks',
        lazy = false,
        dependencies = { { 'ryanoasis/vim-devicons', lazy = false } },
        config = function()
            vim.cmd [[autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\]" contained conceal containedin=ALL]]
            vim.cmd [[autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\[" contained conceal containedin=ALL]]
            vim.cmd [[autocmd FileType nerdtree syntax match NERDTreeDirSlash #/$# containedin=NERDTreeDir conceal contained]]
            vim.cmd [[set fillchars+=vert:\ ]]
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
