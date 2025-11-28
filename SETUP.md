# Neovim Setup - Ручные шаги

## 1. Neovim
```bash
brew install neovim
```
Требуется версия 0.11+

## 2. Nerd Font
Нужен для иконок. Установить любой Nerd Font, например:
```bash
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
```
И выбрать его в терминале.

## 3. Go (для sqls)
```bash
brew install go
# или
brew upgrade go
```
Нужна версия 1.21+

### Добавить go/bin в PATH (nushell)
В `~/.config/nushell/env.nu`:
```nu
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/go/bin")
```

### Установить sqls вручную (Mason не работает)
```bash
go install -ldflags="-s -w" github.com/sqls-server/sqls@latest
```
Флаги `-s -w` обходят баг линкера на macOS.

## 4. .NET SDK (для OmniSharp)
```bash
brew install dotnet
```

OmniSharp устанавливается автоматически через Mason.

### Конфигурация OmniSharp для декомпиляции
Создать `~/.omnisharp/omnisharp.json`:
```json
{
  "RoslynExtensionsOptions": {
    "enableDecompilationSupport": true
  }
}
```

**ВАЖНО:** OmniSharp требует флаг `--languageserver` в cmd (уже добавлен в init.lua).

## 5. Node.js (для некоторых LSP)
```bash
brew install node
```
Нужен для: typescript-language-server, vscode-json-language-server, prettier

## 6. Первый запуск Neovim
```bash
nvim
```
При первом запуске:
1. Lazy.nvim автоматически установится
2. Плагины скачаются
3. Mason установит LSP серверы (кроме sqls)
4. Treesitter скачает парсеры

Можно проверить:
- `:Lazy` — статус плагинов
- `:Mason` — статус LSP серверов
- `:checkhealth` — общая диагностика

## 7. LSP серверы (устанавливаются автоматически через Mason)
- lua_ls — Lua
- omnisharp — C# (с декомпиляцией через omnisharp-extended-lsp.nvim)
- ts_ls — JavaScript/TypeScript
- jsonls — JSON
- lemminx — XML
- marksman — Markdown

## Известные проблемы

### sqls не устанавливается через Mason
Ошибка линкера на macOS. Решение — установить вручную через `go install` (см. п.3).

### csharp-ls декомпиляция не работает
Используем OmniSharp вместо csharp-ls. OmniSharp + omnisharp-extended-lsp.nvim работает.

### dotnet tool зависает
Корпоративные nuget репозитории блокируют. Использовать `--ignore-failed-sources`.

## Полезные команды

```vim
" Статус LSP
:checkhealth lsp

" Открыть Mason
:Mason

" Обновить плагины
:Lazy update

" Обновить LSP серверы
:MasonUpdate

" Обновить Treesitter парсеры
:TSUpdate
```
