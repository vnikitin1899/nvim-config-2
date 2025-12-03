-- Настройки цветовой схемы

-- Используем цвета терминала напрямую
vim.o.termguicolors = true
vim.o.background = 'dark'

-- Настройка выделения строки с курсором
vim.api.nvim_create_autocmd('ColorScheme', {
	pattern = '*',
	callback = function()
		vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#1e1d2e', underline = false })
		vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#a277ff', bg = '#1e1d2e', bold = true })
	end,
})

-- Применяем настройки сразу
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#1e1d2e', underline = false })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#a277ff', bg = '#1e1d2e', bold = true })

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
