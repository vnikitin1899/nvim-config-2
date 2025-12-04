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

-- Подсветка номеров строк для Git изменений
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = function()
        -- Git добавления (зеленый)
        vim.api.nvim_set_hl(0, 'GitSignsAddNr', { fg = '#61ffca', bg = 'NONE', bold = true })
        -- Git изменения (желтый)
        vim.api.nvim_set_hl(0, 'GitSignsChangeNr', { fg = '#ffca85', bg = 'NONE', bold = true })
        -- Git удаления (красный)
        vim.api.nvim_set_hl(0, 'GitSignsDeleteNr', { fg = '#ff6767', bg = 'NONE', bold = true })
    end,
})

-- Применяем настройки сразу
vim.api.nvim_set_hl(0, 'GitSignsAddNr', { fg = '#61ffca', bg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'GitSignsChangeNr', { fg = '#ffca85', bg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'GitSignsDeleteNr', { fg = '#ff6767', bg = 'NONE', bold = true })

-- Подсветка для diff файлов
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = function()
        -- Добавленные строки (зеленый фон)
        vim.api.nvim_set_hl(0, 'DiffAdd', { fg = '#61ffca', bg = '#1e3a1e', bold = false })
        -- Удаленные строки (красный фон)
        vim.api.nvim_set_hl(0, 'DiffDelete', { fg = '#ff6767', bg = '#3a1e1e', bold = false })
        -- Измененные строки (желтый фон)
        vim.api.nvim_set_hl(0, 'DiffChange', { fg = '#ffca85', bg = '#3a3a1e', bold = false })
        -- Текст изменений
        vim.api.nvim_set_hl(0, 'DiffText', { fg = '#ffca85', bg = '#4a4a2e', bold = true })
        -- Заголовки diff (@@ ... @@)
        vim.api.nvim_set_hl(0, 'diffFile', { fg = '#a277ff', bg = 'NONE', bold = true })
        vim.api.nvim_set_hl(0, 'diffIndexLine', { fg = '#82e2ff', bg = 'NONE', bold = false })
        vim.api.nvim_set_hl(0, 'diffLine', { fg = '#82e2ff', bg = 'NONE', bold = true })
        vim.api.nvim_set_hl(0, 'diffSubname', { fg = '#82e2ff', bg = 'NONE', bold = false })
        vim.api.nvim_set_hl(0, 'diffAdded', { fg = '#61ffca', bg = 'NONE', bold = false })
        vim.api.nvim_set_hl(0, 'diffRemoved', { fg = '#ff6767', bg = 'NONE', bold = false })
    end,
})

-- Применяем настройки сразу
vim.api.nvim_set_hl(0, 'DiffAdd', { fg = '#61ffca', bg = '#1e3a1e', bold = false })
vim.api.nvim_set_hl(0, 'DiffDelete', { fg = '#ff6767', bg = '#3a1e1e', bold = false })
vim.api.nvim_set_hl(0, 'DiffChange', { fg = '#ffca85', bg = '#3a3a1e', bold = false })
vim.api.nvim_set_hl(0, 'DiffText', { fg = '#ffca85', bg = '#4a4a2e', bold = true })
vim.api.nvim_set_hl(0, 'diffFile', { fg = '#a277ff', bg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'diffIndexLine', { fg = '#82e2ff', bg = 'NONE', bold = false })
vim.api.nvim_set_hl(0, 'diffLine', { fg = '#82e2ff', bg = 'NONE', bold = true })
vim.api.nvim_set_hl(0, 'diffSubname', { fg = '#82e2ff', bg = 'NONE', bold = false })
vim.api.nvim_set_hl(0, 'diffAdded', { fg = '#61ffca', bg = 'NONE', bold = false })
vim.api.nvim_set_hl(0, 'diffRemoved', { fg = '#ff6767', bg = 'NONE', bold = false })

-- Цвета для rainbow brackets (nvim-ts-rainbow2)
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = function()
        -- Цвета для разных уровней вложенности скобок
        -- nvim-ts-rainbow2 использует группы @punctuation.bracket
        vim.api.nvim_set_hl(0, 'TSRainbowRed', { fg = '#ff6767', bold = true })
        vim.api.nvim_set_hl(0, 'TSRainbowYellow', { fg = '#ffca85', bold = true })
        vim.api.nvim_set_hl(0, 'TSRainbowBlue', { fg = '#82e2ff', bold = true })
        vim.api.nvim_set_hl(0, 'TSRainbowOrange', { fg = '#ffca85', bold = true })
        vim.api.nvim_set_hl(0, 'TSRainbowGreen', { fg = '#61ffca', bold = true })
        vim.api.nvim_set_hl(0, 'TSRainbowViolet', { fg = '#a277ff', bold = true })
        vim.api.nvim_set_hl(0, 'TSRainbowCyan', { fg = '#61ffca', bold = true })
    end,
})

-- Применяем настройки сразу
vim.api.nvim_set_hl(0, 'TSRainbowRed', { fg = '#ff6767', bold = true })
vim.api.nvim_set_hl(0, 'TSRainbowYellow', { fg = '#ffca85', bold = true })
vim.api.nvim_set_hl(0, 'TSRainbowBlue', { fg = '#82e2ff', bold = true })
vim.api.nvim_set_hl(0, 'TSRainbowOrange', { fg = '#ffca85', bold = true })
vim.api.nvim_set_hl(0, 'TSRainbowGreen', { fg = '#61ffca', bold = true })
vim.api.nvim_set_hl(0, 'TSRainbowViolet', { fg = '#a277ff', bold = true })
vim.api.nvim_set_hl(0, 'TSRainbowCyan', { fg = '#61ffca', bold = true })
