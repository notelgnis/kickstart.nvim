# Nvim Hotkeys

## Navigation

### Lines
- `10j` / `10k` - 10 lines down/up
- `10G` or `:10` - go to line 10
- `gg` - start of file
- `G` - end of file

### Words
- `w` / `b` - next/prev word
- `5w` - 5 words forward
- `e` - end of word
- `W` / `B` / `E` - same but WORD (space-separated)

### Line
- `0` - start of line
- `$` - end of line
- `^` - first non-space
- `f{char}` - jump to char (`;` next, `,` prev)
- `t{char}` - jump before char

### Screen
- `H` / `M` / `L` - top/middle/bottom of screen
- `Ctrl+d` / `Ctrl+u` - half page down/up
- `Ctrl+f` / `Ctrl+b` - full page down/up
- `zz` - center cursor on screen

### Code
- `%` - matching bracket
- `{` / `}` - paragraph up/down
- `gd` - go to definition
- `gr` - go to references
- `Ctrl+o` / `Ctrl+i` - jump back/forward

## Yank (Copy)

### Words
- `yw` - yank to end of word
- `yiw` - yank inner word
- `yaw` - yank word + space
- `y5w` - yank 5 words

### Lines
- `yy` - yank line
- `5yy` - yank 5 lines
- `y$` - yank to end of line
- `y0` - yank to start of line

### Other
- `yi"` - yank inside quotes
- `yi(` - yank inside parens
- `yi{` - yank inside braces
- `yip` - yank inner paragraph

## Delete

- `dd` - delete line
- `5dd` - delete 5 lines
- `dw` - delete word
- `diw` - delete inner word
- `di"` - delete inside quotes
- `D` - delete to end of line
- `x` - delete char

## Change (delete + insert)

- `cc` - change line
- `cw` - change word
- `ciw` - change inner word
- `ci"` - change inside quotes
- `C` - change to end of line
- `s` - substitute char

## Visual Mode

- `v` - char visual
- `V` - line visual
- `Ctrl+v` - block visual
- `viw` - select word
- `vi"` - select inside quotes
- `vip` - select paragraph

## Search

- `/pattern` - search forward
- `?pattern` - search backward
- `n` / `N` - next/prev match
- `*` - search word under cursor
- `#` - search word backward

## Replace

- `r{char}` - replace single char
- `R` - replace mode
- `:s/old/new/` - replace first in line
- `:s/old/new/g` - replace all in line
- `:%s/old/new/g` - replace all in file
- `:%s/old/new/gc` - replace with confirm

## Undo/Redo

- `u` - undo
- `Ctrl+r` - redo
- `.` - repeat last command

## Windows

- `Ctrl+w s` - split horizontal
- `Ctrl+w v` - split vertical
- `Ctrl+w h/j/k/l` - move between windows
- `Ctrl+w =` - equal size
- `Ctrl+w q` - close window

## Buffers

- `:e file` - open file
- `:bn` / `:bp` - next/prev buffer
- `:bd` - close buffer
- `:ls` - list buffers

## Macros

- `q{a-z}` - start recording to register
- `q` - stop recording
- `@{a-z}` - play macro
- `@@` - repeat last macro
- `5@a` - play macro 5 times

## Marks

- `m{a-z}` - set mark
- `'{a-z}` - jump to mark line
- `` `{a-z} `` - jump to mark position
- `:marks` - list marks

## Registers

- `"{a-z}y` - yank to register
- `"{a-z}p` - paste from register
- `"0p` - paste last yank (not delete)
- `"+y` / `"+p` - system clipboard
- `:reg` - list registers

## Text Objects

- `i` - inner (without surrounding)
- `a` - around (with surrounding)
- `w` - word
- `s` - sentence
- `p` - paragraph
- `"` `'` `` ` `` - quotes
- `(` `)` `{` `}` `[` `]` - brackets
- `t` - tag (HTML/XML)

Examples: `ciw`, `da"`, `yip`, `vi{`

## Comments (mini.comment)

- `gcc` - toggle comment line
- `gc{motion}` - comment motion (e.g. `gcip` paragraph, `gc5j` 5 lines)
- `gc` (visual) - comment selection

## Surround (mini.surround)

- `sa{motion}{char}` - add surround (`saiw"` wrap word in quotes)
- `sd{char}` - delete surround (`sd"` remove quotes)
- `sr{old}{new}` - replace surround (`sr"'` change " to ')

Examples:
- `saiw(` - `word` → `(word)`
- `sa2w"` - wrap 2 words in quotes
- `sd'` - `'text'` → `text`
- `sr({` - `(x)` → `{x}`

## Jump (mini.jump)

- `f{char}` - jump to char, then `f` to repeat
- `t{char}` - jump before char, then `t` to repeat
- `F`/`T` - same backwards

## Splitjoin (mini.splitjoin)

- `gS` - toggle split/join arguments, arrays, objects

```
{ a: 1, b: 2 }  <-->  {
                        a: 1,
                        b: 2
                      }
```

## Misc

- `J` - join lines
- `~` - toggle case
- `gU{motion}` - uppercase
- `gu{motion}` - lowercase
- `>` / `<` - indent/unindent (visual)
- `=` - auto indent
- `Ctrl+a` / `Ctrl+x` - increment/decrement number
