FROM debian:stable-slim

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    git curl wget unzip ripgrep fd-find make gcc g++ \
    python3 python3-pip nodejs npm ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Установка свежего Neovim (из GitHub releases)
RUN curl -LO https://github.com/neovim/neovim/releases/download/v0.11.0/nvim-linux-x86_64.tar.gz \
    && tar -xzf nvim-linux-x86_64.tar.gz \
    && mv nvim-linux-x86_64 /opt/nvim \
    && ln -s /opt/nvim/bin/nvim /usr/local/bin/nvim \
    && rm nvim-linux-x86_64.tar.gz

ENV NVIM_APPNAME=nvim
WORKDIR /root

# Копируем конфиг
COPY . /root/.config/nvim

# Создаём директории для плагинов
RUN mkdir -p /root/.local/share/nvim /root/.local/state/nvim

# Устанавливаем плагины и treesitter парсеры
RUN nvim --headless "+Lazy! sync" +qa || true
RUN nvim --headless "+TSUpdateSync" +qa || true

# Устанавливаем LSP серверы через Mason
RUN nvim --headless "+MasonInstall lua-language-server typescript-language-server json-lsp" +qa || true

WORKDIR /workspace
CMD ["nvim"]
