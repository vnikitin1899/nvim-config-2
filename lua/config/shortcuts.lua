-- Пользовательские маппинги

-- Открытие Telescope для поиска файлов по ff
vim.keymap.set('n', 'ff', function()
    require('telescope.builtin').find_files()
end, { desc = 'Telescope: Find files' })
