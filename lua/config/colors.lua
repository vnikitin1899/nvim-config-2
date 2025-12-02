-- Настройки цветовой схемы для использования цветов терминала

-- Используем цвета терминала напрямую
vim.o.termguicolors = true

-- Определяем цветовую схему терминала и применяем её
local function setup_terminal_colors()
    -- Используем встроенную схему default, которая использует цвета терминала
    -- или определяем схему на основе переменной окружения TERM_THEME
    local term_theme = os.getenv('TERM_THEME') or 'default'
    
    -- Если терминал поддерживает 256 цветов, используем схему default
    -- которая автоматически адаптируется под цвета терминала
    vim.cmd('colorscheme default')
    
    -- Настраиваем цвета так, чтобы они брались из терминала
    vim.o.background = 'dark'  -- или 'light', в зависимости от темы терминала
    
    -- Используем цвета терминала для основных групп
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE', fg = 'NONE' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'NONE' })
end

-- Применяем настройки при запуске
setup_terminal_colors()

-- Группы подсветки для TypeScript и JSDoc комментариев
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = function()
        -- Подсветка JSDoc тегов (@param, @returns, и т.д.)
        vim.api.nvim_set_hl(0, '@comment.documentation', { link = 'Comment' })
        vim.api.nvim_set_hl(0, '@lsp.type.comment.javascript', { link = 'Comment' })
        vim.api.nvim_set_hl(0, '@lsp.type.comment.typescript', { link = 'Comment' })
        
        -- Улучшенная подсветка для TypeScript элементов
        -- Типы и интерфейсы
        vim.api.nvim_set_hl(0, '@type.typescript', { link = 'Type' })
        vim.api.nvim_set_hl(0, '@type.builtin.typescript', { link = 'Type' })
        vim.api.nvim_set_hl(0, '@type.qualifier.typescript', { link = 'Type' })
        
        -- Ключевые слова TypeScript
        vim.api.nvim_set_hl(0, '@keyword.typescript', { link = 'Keyword' })
        vim.api.nvim_set_hl(0, '@keyword.function.typescript', { link = 'Keyword' })
        vim.api.nvim_set_hl(0, '@keyword.operator.typescript', { link = 'Operator' })
        
        -- Переменные и параметры
        vim.api.nvim_set_hl(0, '@variable.typescript', { link = 'Identifier' })
        vim.api.nvim_set_hl(0, '@parameter.typescript', { link = 'Identifier' })
        vim.api.nvim_set_hl(0, '@property.typescript', { link = 'Identifier' })
        
        -- Функции и методы
        vim.api.nvim_set_hl(0, '@function.typescript', { link = 'Function' })
        vim.api.nvim_set_hl(0, '@function.call.typescript', { link = 'Function' })
        vim.api.nvim_set_hl(0, '@method.typescript', { link = 'Function' })
        vim.api.nvim_set_hl(0, '@method.call.typescript', { link = 'Function' })
        
        -- Строки и числа
        vim.api.nvim_set_hl(0, '@string.typescript', { link = 'String' })
        vim.api.nvim_set_hl(0, '@number.typescript', { link = 'Number' })
        vim.api.nvim_set_hl(0, '@boolean.typescript', { link = 'Boolean' })
        
        -- Операторы
        vim.api.nvim_set_hl(0, '@operator.typescript', { link = 'Operator' })
        vim.api.nvim_set_hl(0, '@punctuation.typescript', { link = 'Delimiter' })
        
        -- Декораторы и модификаторы доступа
        vim.api.nvim_set_hl(0, '@decorator.typescript', { link = 'Function' })
        vim.api.nvim_set_hl(0, '@modifier.typescript', { link = 'Keyword' })
    end,
})

-- Убеждаемся, что treesitter используется для TypeScript файлов
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    callback = function()
        -- Treesitter автоматически обрабатывает подсветку для этих типов файлов
        -- Дополнительная настройка не требуется
    end,
})
