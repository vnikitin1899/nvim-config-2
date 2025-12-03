-- Пользовательские маппинги

-- Открытие Telescope для поиска файлов по ff
vim.keymap.set('n', 'ff', function()
    require('telescope.builtin').find_files({
        layout_strategy = 'flex',
        layout_config = {
            flex = {
                flip_columns = 120,
            },
            horizontal = {
                preview_width = 0.5,
                preview_cutoff = 120,
            },
            vertical = {
                preview_height = 0.5,
            },
            width = 0.9,
            height = 0.9,
            prompt_position = 'bottom',
        },
        preview = {
            enabled = true,
            hide_on_startup = false,
        },
    })
end, { desc = 'Telescope: Find files' })

-- Открытие Telescope для поиска слов среди файлов по fg
vim.keymap.set('n', 'fg', function()
    require('telescope.builtin').live_grep({
        layout_strategy = 'vertical',
        layout_config = {
            vertical = {
                width = 0.9,
                height = 0.9,
                preview_height = 0.4,
                preview_cutoff = 1,
                mirror = true,
            },
            prompt_position = 'bottom',
        },
        preview = {
            enabled = true,
            hide_on_startup = false,
        },
        path_display = { 'truncate' },
    })
end, { desc = 'Telescope: Live grep (search words in files)' })
