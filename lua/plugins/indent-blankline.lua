return {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
        local highlight = {
            'IndentBlanklineIndent1',
            'IndentBlanklineIndent2',
            'IndentBlanklineIndent3',
            'IndentBlanklineIndent4',
            'IndentBlanklineIndent5',
            'IndentBlanklineIndent6',
        }
        
        local hooks = require('ibl.hooks')
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            -- Настройка цветов для rainbow indent
            vim.api.nvim_set_hl(0, 'IndentBlanklineIndent1', { fg = '#a277ff', nocombine = true })
            vim.api.nvim_set_hl(0, 'IndentBlanklineIndent2', { fg = '#61ffca', nocombine = true })
            vim.api.nvim_set_hl(0, 'IndentBlanklineIndent3', { fg = '#ffca85', nocombine = true })
            vim.api.nvim_set_hl(0, 'IndentBlanklineIndent4', { fg = '#ff6767', nocombine = true })
            vim.api.nvim_set_hl(0, 'IndentBlanklineIndent5', { fg = '#82e2ff', nocombine = true })
            vim.api.nvim_set_hl(0, 'IndentBlanklineIndent6', { fg = '#a277ff', nocombine = true })
        end)
        
        require('ibl').setup({
            indent = {
                char = '│',
                highlight = highlight,
            },
            scope = {
                enabled = true,
                show_start = true,
                show_end = false,
            },
        })
        
        -- Автоматическое применение цветов после загрузки цветовой схемы
        vim.api.nvim_create_autocmd('ColorScheme', {
            callback = function()
                vim.api.nvim_set_hl(0, 'IndentBlanklineIndent1', { fg = '#a277ff', nocombine = true })
                vim.api.nvim_set_hl(0, 'IndentBlanklineIndent2', { fg = '#61ffca', nocombine = true })
                vim.api.nvim_set_hl(0, 'IndentBlanklineIndent3', { fg = '#ffca85', nocombine = true })
                vim.api.nvim_set_hl(0, 'IndentBlanklineIndent4', { fg = '#ff6767', nocombine = true })
                vim.api.nvim_set_hl(0, 'IndentBlanklineIndent5', { fg = '#82e2ff', nocombine = true })
                vim.api.nvim_set_hl(0, 'IndentBlanklineIndent6', { fg = '#a277ff', nocombine = true })
            end,
        })
    end,
}
