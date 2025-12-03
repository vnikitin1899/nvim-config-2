return {
    'nvim-telescope/telescope.nvim', tag = 'v0.2.0',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local telescope = require('telescope')
        
        telescope.setup({
            defaults = {
                -- Включение превью по умолчанию
                preview = {
                    enabled = true,
                    hide_on_startup = false,
                },
                -- Правильный формат для парсинга результатов grep
                vimgrep_arguments = {
                    'rg',
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    '--smart-case',
                },
            },
            pickers = {
                find_files = {
                    -- Включение превью для find_files
                    preview = {
                        enabled = true,
                        hide_on_startup = false,
                    },
                },
                live_grep = {
                    -- Включение превью для live_grep
                    preview = {
                        enabled = true,
                        hide_on_startup = false,
                    },
                    -- Компактное отображение путей
                    path_display = { 'truncate' },
                },
            },
        })
    end,
}
