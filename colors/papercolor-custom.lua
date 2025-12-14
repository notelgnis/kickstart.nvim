-- PaperColor Custom colorscheme for Neovim
-- Based on PaperColor with custom overrides

vim.cmd('hi clear')
if vim.fn.exists('syntax_on') then
    vim.cmd('syntax reset')
end
vim.o.termguicolors = true
vim.o.background = 'light'
vim.g.colors_name = 'papercolor-custom'

-- Load PaperColor as base
vim.cmd('runtime colors/PaperColor.vim')

-- Palette
local c = {
    bg = 'NONE',
    bg_solid = '#eeeeee',
    bg_alt = '#e0e0e0',
    fg = '#424242',
    fg_dim = '#666666',
    grey = '#888888',
    red = '#d75f5f',
    green = '#10a778',
    yellow = '#F3BF5D',
    blue = '#6699cc',
    cyan = '#93bfc2',
    orange = '#F4AE59',
    dark = '#101B1D',
    none = 'NONE',
}

local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Transparent backgrounds
hi('Normal', { bg = c.bg })
hi('NormalNC', { bg = c.bg })
hi('NormalFloat', { fg = c.fg, bg = c.bg })
hi('SignColumn', { bg = c.bg })
hi('LineNr', { fg = c.grey, bg = c.bg })
hi('CursorLineNr', { fg = c.fg, bg = c.bg_alt, bold = true })

-- Search
hi('Search', { fg = c.dark, bg = c.yellow })
hi('IncSearch', { fg = c.dark, bg = c.yellow, bold = true })
hi('CurSearch', { fg = c.dark, bg = c.orange, bold = true })

-- Statusline
hi('StatusLine', { fg = c.fg, bg = c.bg })
hi('StatusLineNC', { fg = c.grey, bg = c.bg })
hi('StatusLineTerm', { fg = c.fg, bg = c.bg })
hi('StatusLineTermNC', { fg = c.grey, bg = c.bg })

-- WinBar
hi('WinBar', { fg = c.fg, bg = c.bg })
hi('WinBarNC', { fg = c.grey, bg = c.bg })

-- Terminal
hi('Terminal', { fg = c.fg, bg = c.bg })

-- Neo-tree
hi('NeoTreeNormal', { bg = c.bg })
hi('NeoTreeNormalNC', { bg = c.bg })
hi('NeoTreeEndOfBuffer', { bg = c.bg })
hi('NeoTreeStatusLine', { fg = c.bg, bg = c.bg })
hi('NeoTreeDirectoryIcon', { fg = '#af0000' })

-- Mini.statusline
hi('MiniStatuslineFilename', { fg = c.green, bg = c.bg })
hi('MiniStatuslineDevinfo', { fg = c.fg, bg = c.bg })
hi('MiniStatuslineFileinfo', { fg = c.green, bg = c.bg })
hi('MiniStatuslineInactive', { fg = c.grey, bg = c.bg })
hi('MiniStatuslineModeNormal', { fg = c.bg_solid, bg = c.green, bold = true })
hi('MiniStatuslineModeInsert', { fg = c.bg_solid, bg = c.blue, bold = true })
hi('MiniStatuslineModeVisual', { fg = c.bg_solid, bg = '#c678dd', bold = true })
hi('MiniStatuslineModeReplace', { fg = c.bg_solid, bg = c.red, bold = true })
hi('MiniStatuslineModeCommand', { fg = c.bg_solid, bg = c.green, bold = true })

-- Barbar bufferline
hi('BufferTabpageFill', { bg = c.bg_alt })
hi('BufferCurrent', { fg = c.fg, bg = c.bg_alt })
hi('BufferCurrentIndex', { fg = c.fg, bg = c.bg_alt })
hi('BufferCurrentMod', { fg = c.fg, bg = c.bg_alt })
hi('BufferCurrentSign', { fg = c.green, bg = c.bg_alt })
hi('BufferCurrentIcon', { bg = c.bg_alt })
hi('BufferCurrentTarget', { fg = c.red, bg = c.bg_alt })
hi('BufferInactive', { fg = c.grey, bg = c.bg_alt })
hi('BufferInactiveIndex', { fg = c.grey, bg = c.bg_alt })
hi('BufferInactiveMod', { fg = c.grey, bg = c.bg_alt })
hi('BufferInactiveSign', { fg = c.grey, bg = c.bg_alt })
hi('BufferInactiveIcon', { bg = c.bg_alt })
hi('BufferInactiveTarget', { fg = c.grey, bg = c.bg_alt })
hi('BufferVisible', { fg = c.fg_dim, bg = c.bg_alt })
hi('BufferVisibleIndex', { fg = c.fg_dim, bg = c.bg_alt })
hi('BufferVisibleMod', { fg = c.fg_dim, bg = c.bg_alt })
hi('BufferVisibleSign', { fg = c.fg_dim, bg = c.bg_alt })
hi('BufferVisibleIcon', { bg = c.bg_alt })
hi('BufferVisibleTarget', { fg = c.red, bg = c.bg_alt })

-- Git Signs
hi('GitSignsCurrentLineBlame', { fg = c.grey, bg = c.bg })

-- Snacks picker
hi('SnacksPickerMatch', { fg = c.dark, bg = c.yellow, bold = true })

-- Indent Blankline
hi('IblIndent', { fg = '#d0d0d0' })
hi('IblScope', { fg = c.grey })

-- Sidekick
hi('SidekickChat', { fg = c.fg, bg = c.bg })

-- Render Markdown
hi('RenderMarkdownCode', { bg = c.bg })
hi('RenderMarkdownCodeInline', { bg = c.bg })
hi('RenderMarkdownH1Bg', { bg = c.bg })
hi('RenderMarkdownH2Bg', { bg = c.bg })
hi('RenderMarkdownH3Bg', { bg = c.bg })
hi('RenderMarkdownH4Bg', { bg = c.bg })
hi('RenderMarkdownH5Bg', { bg = c.bg })
hi('RenderMarkdownH6Bg', { bg = c.bg })
