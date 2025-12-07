-- Telemetry colorscheme for Neovim
-- "Encrypt the signal; the void is listening."

vim.cmd('hi clear')
if vim.fn.exists('syntax_on') then
    vim.cmd('syntax reset')
end
vim.o.termguicolors = true
vim.g.colors_name = 'telemetry'

-- Palette
local c = {
    bg = '#0F1B1D',
    bg_alt = '#162224',
    bg_light = '#1d2e31',
    fg = '#9abfbe',
    fg_bright = '#b8d4d3',
    fg_dim = '#7a9a99',
    grey = '#6b8d94',
    red = '#c27166',
    red_bright = '#c9918a',
    green = '#8dac8b',
    green_bright = '#a3bca1',
    yellow = '#d49a4f',
    yellow_bright = '#dbb078',
    blue = '#7da5a8',
    blue_bright = '#9bbbbe',
    magenta = '#c4847a',
    magenta_bright = '#d4a49c',
    cyan = '#8fb5b3',
    cyan_bright = '#a5c5c4',
    orange = '#F3BF5D',
    none = 'NONE',
}

local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Editor
hi('Normal', { fg = c.fg, bg = c.bg })
hi('NormalFloat', { fg = c.fg, bg = c.bg_alt })
hi('NormalNC', { fg = c.fg, bg = c.bg })
hi('Cursor', { fg = c.bg, bg = c.yellow })
hi('CursorLine', { bg = c.bg_alt })
hi('CursorLineNr', { fg = c.yellow, bg = c.bg_alt, bold = true })
hi('CursorColumn', { bg = c.bg_alt })
hi('ColorColumn', { bg = c.bg_alt })
hi('LineNr', { fg = c.grey })
hi('SignColumn', { fg = c.grey, bg = c.bg })
hi('VertSplit', { fg = c.bg_light, bg = c.bg })
hi('WinSeparator', { fg = c.bg_light, bg = c.bg })
hi('Folded', { fg = c.grey, bg = c.bg_alt })
hi('FoldColumn', { fg = c.grey, bg = c.bg })
hi('NonText', { fg = c.bg_light })
hi('EndOfBuffer', { fg = c.bg })
hi('SpecialKey', { fg = c.bg_light })
hi('Whitespace', { fg = c.bg_light })

-- Search & Selection
hi('Search', { fg = c.bg, bg = c.yellow })
hi('IncSearch', { fg = c.bg, bg = c.orange })
hi('CurSearch', { fg = c.bg, bg = c.orange })
hi('Visual', { bg = c.bg_light })
hi('VisualNOS', { bg = c.bg_light })
hi('Substitute', { fg = c.bg, bg = c.red })

-- Statusline & Tabline
hi('StatusLine', { fg = c.fg, bg = c.bg })
hi('StatusLineNC', { fg = c.grey, bg = c.bg })
hi('TabLine', { fg = c.grey, bg = c.bg_alt })
hi('TabLineFill', { bg = c.bg_alt })
hi('TabLineSel', { fg = c.fg, bg = c.bg })
hi('WinBar', { fg = c.fg, bg = c.bg })
hi('WinBarNC', { fg = c.grey, bg = c.bg })

-- Popup menu
hi('Pmenu', { fg = c.fg, bg = c.bg_alt })
hi('PmenuSel', { fg = c.bg, bg = c.blue })
hi('PmenuSbar', { bg = c.bg_light })
hi('PmenuThumb', { bg = c.grey })

-- Messages
hi('ErrorMsg', { fg = c.red })
hi('WarningMsg', { fg = c.yellow })
hi('ModeMsg', { fg = c.fg, bold = true })
hi('MoreMsg', { fg = c.green })
hi('Question', { fg = c.green })
hi('Title', { fg = c.yellow, bold = true })
hi('Directory', { fg = c.blue })
hi('Conceal', { fg = c.grey })
hi('MatchParen', { fg = c.orange, bg = c.bg_light, bold = true })

-- Diff
hi('DiffAdd', { fg = c.green, bg = c.bg_alt })
hi('DiffChange', { fg = c.yellow, bg = c.bg_alt })
hi('DiffDelete', { fg = c.red, bg = c.bg_alt })
hi('DiffText', { fg = c.bg, bg = c.yellow })
hi('diffAdded', { fg = c.green })
hi('diffRemoved', { fg = c.red })
hi('diffChanged', { fg = c.yellow })
hi('diffFile', { fg = c.cyan })
hi('diffNewFile', { fg = c.green })
hi('diffOldFile', { fg = c.red })

-- Spell
hi('SpellBad', { undercurl = true, sp = c.red })
hi('SpellCap', { undercurl = true, sp = c.yellow })
hi('SpellLocal', { undercurl = true, sp = c.blue })
hi('SpellRare', { undercurl = true, sp = c.magenta })

-- Syntax
hi('Comment', { fg = c.grey, italic = true })

hi('Constant', { fg = c.magenta })
hi('String', { fg = c.green })
hi('Character', { fg = c.green })
hi('Number', { fg = c.magenta })
hi('Boolean', { fg = c.magenta })
hi('Float', { fg = c.magenta })

hi('Identifier', { fg = c.fg })
hi('Function', { fg = c.yellow })

hi('Statement', { fg = c.red })
hi('Conditional', { fg = c.red })
hi('Repeat', { fg = c.red })
hi('Label', { fg = c.red })
hi('Operator', { fg = c.cyan })
hi('Keyword', { fg = c.red })
hi('Exception', { fg = c.red })

hi('PreProc', { fg = c.cyan })
hi('Include', { fg = c.red })
hi('Define', { fg = c.cyan })
hi('Macro', { fg = c.cyan })
hi('PreCondit', { fg = c.cyan })

hi('Type', { fg = c.yellow })
hi('StorageClass', { fg = c.yellow })
hi('Structure', { fg = c.yellow })
hi('Typedef', { fg = c.yellow })

hi('Special', { fg = c.orange })
hi('SpecialChar', { fg = c.orange })
hi('Tag', { fg = c.red })
hi('Delimiter', { fg = c.fg_dim })
hi('SpecialComment', { fg = c.grey })
hi('Debug', { fg = c.orange })

hi('Underlined', { fg = c.blue, underline = true })
hi('Ignore', { fg = c.grey })
hi('Error', { fg = c.red })
hi('Todo', { fg = c.bg, bg = c.yellow, bold = true })

-- Treesitter
hi('@variable', { fg = c.fg })
hi('@variable.builtin', { fg = c.magenta })
hi('@variable.parameter', { fg = c.fg_dim })
hi('@variable.member', { fg = c.fg })
hi('@constant', { fg = c.magenta })
hi('@constant.builtin', { fg = c.magenta })
hi('@constant.macro', { fg = c.magenta })
hi('@module', { fg = c.cyan })
hi('@label', { fg = c.red })

hi('@string', { fg = c.green })
hi('@string.documentation', { fg = c.green })
hi('@string.regexp', { fg = c.orange })
hi('@string.escape', { fg = c.orange })
hi('@string.special', { fg = c.orange })
hi('@character', { fg = c.green })
hi('@character.special', { fg = c.orange })
hi('@boolean', { fg = c.magenta })
hi('@number', { fg = c.magenta })
hi('@number.float', { fg = c.magenta })

hi('@type', { fg = c.yellow })
hi('@type.builtin', { fg = c.yellow })
hi('@type.definition', { fg = c.yellow })
hi('@type.qualifier', { fg = c.red })
hi('@attribute', { fg = c.cyan })
hi('@property', { fg = c.fg })

hi('@function', { fg = c.yellow })
hi('@function.builtin', { fg = c.yellow })
hi('@function.call', { fg = c.yellow })
hi('@function.macro', { fg = c.cyan })
hi('@function.method', { fg = c.yellow })
hi('@function.method.call', { fg = c.yellow })
hi('@constructor', { fg = c.yellow })

hi('@keyword', { fg = c.red })
hi('@keyword.coroutine', { fg = c.red })
hi('@keyword.function', { fg = c.red })
hi('@keyword.operator', { fg = c.cyan })
hi('@keyword.import', { fg = c.red })
hi('@keyword.storage', { fg = c.red })
hi('@keyword.repeat', { fg = c.red })
hi('@keyword.return', { fg = c.red })
hi('@keyword.debug', { fg = c.red })
hi('@keyword.exception', { fg = c.red })
hi('@keyword.conditional', { fg = c.red })
hi('@keyword.directive', { fg = c.cyan })

hi('@punctuation.delimiter', { fg = c.fg_dim })
hi('@punctuation.bracket', { fg = c.fg_dim })
hi('@punctuation.special', { fg = c.cyan })

hi('@comment', { fg = c.grey, italic = true })
hi('@comment.documentation', { fg = c.grey })
hi('@comment.error', { fg = c.red })
hi('@comment.warning', { fg = c.yellow })
hi('@comment.todo', { fg = c.bg, bg = c.yellow })
hi('@comment.note', { fg = c.blue })

hi('@markup.strong', { bold = true })
hi('@markup.italic', { italic = true })
hi('@markup.strikethrough', { strikethrough = true })
hi('@markup.underline', { underline = true })
hi('@markup.heading', { fg = c.yellow, bold = true })
hi('@markup.quote', { fg = c.grey, italic = true })
hi('@markup.math', { fg = c.magenta })
hi('@markup.link', { fg = c.blue })
hi('@markup.link.label', { fg = c.cyan })
hi('@markup.link.url', { fg = c.blue, underline = true })
hi('@markup.raw', { fg = c.green })
hi('@markup.list', { fg = c.red })

hi('@diff.plus', { fg = c.green })
hi('@diff.minus', { fg = c.red })
hi('@diff.delta', { fg = c.yellow })

hi('@tag', { fg = c.red })
hi('@tag.attribute', { fg = c.yellow })
hi('@tag.delimiter', { fg = c.fg_dim })

-- LSP Semantic Tokens
hi('@lsp.type.class', { fg = c.yellow })
hi('@lsp.type.decorator', { fg = c.cyan })
hi('@lsp.type.enum', { fg = c.yellow })
hi('@lsp.type.enumMember', { fg = c.magenta })
hi('@lsp.type.function', { fg = c.yellow })
hi('@lsp.type.interface', { fg = c.yellow })
hi('@lsp.type.macro', { fg = c.cyan })
hi('@lsp.type.method', { fg = c.yellow })
hi('@lsp.type.namespace', { fg = c.cyan })
hi('@lsp.type.parameter', { fg = c.fg_dim })
hi('@lsp.type.property', { fg = c.fg })
hi('@lsp.type.struct', { fg = c.yellow })
hi('@lsp.type.type', { fg = c.yellow })
hi('@lsp.type.typeParameter', { fg = c.yellow })
hi('@lsp.type.variable', { fg = c.fg })

-- Diagnostics
hi('DiagnosticError', { fg = c.red })
hi('DiagnosticWarn', { fg = c.yellow })
hi('DiagnosticInfo', { fg = c.blue })
hi('DiagnosticHint', { fg = c.cyan })
hi('DiagnosticOk', { fg = c.green })
hi('DiagnosticUnderlineError', { undercurl = true, sp = c.red })
hi('DiagnosticUnderlineWarn', { undercurl = true, sp = c.yellow })
hi('DiagnosticUnderlineInfo', { undercurl = true, sp = c.blue })
hi('DiagnosticUnderlineHint', { undercurl = true, sp = c.cyan })
hi('DiagnosticUnderlineOk', { undercurl = true, sp = c.green })
hi('DiagnosticVirtualTextError', { fg = c.red, bg = c.bg_alt })
hi('DiagnosticVirtualTextWarn', { fg = c.yellow, bg = c.bg_alt })
hi('DiagnosticVirtualTextInfo', { fg = c.blue, bg = c.bg_alt })
hi('DiagnosticVirtualTextHint', { fg = c.cyan, bg = c.bg_alt })
hi('DiagnosticVirtualTextOk', { fg = c.green, bg = c.bg_alt })

-- Git Signs
hi('GitSignsAdd', { fg = c.green })
hi('GitSignsChange', { fg = c.yellow })
hi('GitSignsDelete', { fg = c.red })
hi('GitSignsCurrentLineBlame', { fg = c.grey })

-- Neo-tree
hi('NeoTreeNormal', { fg = c.fg, bg = c.bg })
hi('NeoTreeNormalNC', { fg = c.fg, bg = c.bg })
hi('NeoTreeDirectoryIcon', { fg = c.red })
hi('NeoTreeDirectoryName', { fg = c.blue })
hi('NeoTreeRootName', { fg = c.yellow, bold = true })
hi('NeoTreeFileName', { fg = c.fg })
hi('NeoTreeFileIcon', { fg = c.fg })
hi('NeoTreeGitAdded', { fg = c.green })
hi('NeoTreeGitConflict', { fg = c.red })
hi('NeoTreeGitDeleted', { fg = c.red })
hi('NeoTreeGitIgnored', { fg = c.grey })
hi('NeoTreeGitModified', { fg = c.yellow })
hi('NeoTreeGitUnstaged', { fg = c.yellow })
hi('NeoTreeGitUntracked', { fg = c.cyan })
hi('NeoTreeGitStaged', { fg = c.green })
hi('NeoTreeIndentMarker', { fg = c.bg_light })
hi('NeoTreeEndOfBuffer', { fg = c.bg, bg = c.bg })

-- Telescope
hi('TelescopeNormal', { fg = c.fg, bg = c.bg })
hi('TelescopeBorder', { fg = c.grey, bg = c.bg })
hi('TelescopePromptNormal', { fg = c.fg, bg = c.bg_alt })
hi('TelescopePromptBorder', { fg = c.grey, bg = c.bg_alt })
hi('TelescopePromptTitle', { fg = c.bg, bg = c.yellow })
hi('TelescopePreviewTitle', { fg = c.bg, bg = c.green })
hi('TelescopeResultsTitle', { fg = c.bg, bg = c.blue })
hi('TelescopeSelection', { bg = c.bg_light })
hi('TelescopeMatching', { fg = c.yellow, bold = true })

-- Which-key
hi('WhichKey', { fg = c.yellow })
hi('WhichKeyGroup', { fg = c.blue })
hi('WhichKeyDesc', { fg = c.fg })
hi('WhichKeySeparator', { fg = c.grey })
hi('WhichKeyFloat', { bg = c.bg_alt })
hi('WhichKeyBorder', { fg = c.grey, bg = c.bg_alt })
hi('WhichKeyValue', { fg = c.grey })

-- Indent Blankline
hi('IblIndent', { fg = c.bg_light })
hi('IblScope', { fg = c.grey })

-- Barbar bufferline
hi('BufferCurrent', { fg = c.yellow, bg = c.bg_alt })
hi('BufferCurrentIndex', { fg = c.yellow, bg = c.bg_alt })
hi('BufferCurrentMod', { fg = c.yellow, bg = c.bg_alt })
hi('BufferCurrentSign', { fg = c.yellow, bg = c.bg_alt })
hi('BufferCurrentIcon', { bg = c.bg_alt })
hi('BufferCurrentTarget', { fg = c.red, bg = c.bg_alt })
hi('BufferInactive', { fg = c.grey, bg = c.bg_alt })
hi('BufferInactiveIndex', { fg = c.grey, bg = c.bg_alt })
hi('BufferInactiveMod', { fg = c.grey, bg = c.bg_alt })
hi('BufferInactiveSign', { fg = c.grey, bg = c.bg_alt })
hi('BufferInactiveIcon', { bg = c.bg_alt })
hi('BufferInactiveTarget', { fg = c.red, bg = c.bg_alt })
hi('BufferVisible', { fg = c.fg_dim, bg = c.bg_alt })
hi('BufferVisibleIndex', { fg = c.fg_dim, bg = c.bg_alt })
hi('BufferVisibleMod', { fg = c.yellow, bg = c.bg_alt })
hi('BufferVisibleSign', { fg = c.fg_dim, bg = c.bg_alt })
hi('BufferVisibleIcon', { bg = c.bg_alt })
hi('BufferVisibleTarget', { fg = c.red, bg = c.bg_alt })
hi('BufferTabpageFill', { bg = c.bg_alt })

-- Mini.statusline
hi('MiniStatuslineFilename', { fg = c.green, bg = c.bg })
hi('MiniStatuslineDevinfo', { fg = '#ed9366', bg = c.bg })
hi('MiniStatuslineFileinfo', { fg = c.green, bg = c.bg })
hi('MiniStatuslineInactive', { fg = c.grey, bg = c.bg })
hi('MiniStatuslineModeNormal', { fg = c.bg, bg = c.yellow, bold = true })
hi('MiniStatuslineModeInsert', { fg = c.bg, bg = c.blue, bold = true })
hi('MiniStatuslineModeVisual', { fg = c.bg, bg = c.magenta, bold = true })
hi('MiniStatuslineModeReplace', { fg = c.bg, bg = c.red, bold = true })
hi('MiniStatuslineModeCommand', { fg = c.bg, bg = c.green, bold = true })
hi('MiniStatuslineModeOther', { fg = c.bg, bg = c.cyan, bold = true })

-- Dashboard
hi('DashboardHeader', { fg = c.green })
hi('DashboardFooter', { fg = c.grey })
hi('DashboardCenter', { fg = c.yellow })
hi('DashboardShortcut', { fg = c.cyan })

-- Lazy
hi('LazyH1', { fg = c.bg, bg = c.yellow, bold = true })
hi('LazyButton', { fg = c.fg, bg = c.bg_alt })
hi('LazyButtonActive', { fg = c.bg, bg = c.green })
hi('LazySpecial', { fg = c.cyan })

-- Mason
hi('MasonHeader', { fg = c.bg, bg = c.yellow, bold = true })
hi('MasonHighlight', { fg = c.cyan })
hi('MasonHighlightBlock', { fg = c.bg, bg = c.green })
hi('MasonHighlightBlockBold', { fg = c.bg, bg = c.green, bold = true })
hi('MasonMuted', { fg = c.grey })
hi('MasonMutedBlock', { fg = c.fg, bg = c.bg_alt })
