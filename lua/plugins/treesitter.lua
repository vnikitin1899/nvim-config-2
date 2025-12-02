return {
    'nvim-treesitter/nvim-treesitter',
    -- Предотвращаем синхронную установку парсеров при каждом запуске
    sync_install = false,
    config = function()
        require('nvim-treesitter.configs').setup({
            -- Включение подсветки синтаксиса
            highlight = {
                enable = true,
                -- Отключаем стандартную подсветку vim для TypeScript/JavaScript файлов
                -- чтобы использовать только treesitter
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
                -- Включение дополнительной подсветки для JSDoc комментариев
                additional_vim_regex_highlighting = { 'javascript', 'typescript', 'tsx' },
            },
            -- Включение инкрементального выделения
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = 'gnn',
                    node_incremental = 'grn',
                    scope_incremental = 'grc',
                    node_decremental = 'grm',
                },
            },
            -- Включение индентации на основе деревьев
            indent = {
                enable = true,
            },
            -- Парсеры для языков
            -- sync_install = false предотвращает синхронную установку при каждом запуске
            ensure_installed = {
                -- TypeScript и JavaScript
                'typescript',
                'tsx',  -- TypeScript с JSX
                'javascript',  -- JavaScript с поддержкой JSX
                
                -- Веб-разработка
                'html',
                'css',
                'scss',
                'json',
                'yaml',
                'toml',
                
                -- React + TS экосистема
                'graphql',
                'sql',
                'dockerfile',
                
                -- Запрошенные языки
                'java',
                'xml',
                'editorconfig',
                'markdown',
                
                -- Дополнительные полезные форматы
                'bash',
                'gitignore',
                'gitcommit',
                'diff',
                'regex',
                'lua',
            },
        })
    end,
}
