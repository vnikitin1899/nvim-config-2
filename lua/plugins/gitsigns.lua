return {
    'lewis6991/gitsigns.nvim',
    config = function()
        require('gitsigns').setup({
            signs = {
                add = { text = '│', numhl = 'GitSignsAddNr' },
                change = { text = '│', numhl = 'GitSignsChangeNr' },
                delete = { text = '_', numhl = 'GitSignsDeleteNr' },
                topdelete = { text = '‾', numhl = 'GitSignsDeleteNr' },
                changedelete = { text = '~', numhl = 'GitSignsChangeNr' },
            },
            numhl = true, -- Подсветка номеров строк
            linehl = false, -- Не подсвечивать всю строку
            signcolumn = true, -- Показывать колонку знаков
            watch_gitdir = {
                interval = 1000,
                follow_files = true,
            },
            attach_to_untracked = true,
            current_line_blame = false,
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil,
            max_file_length = 40000,
            preview_config = {
                border = 'single',
                style = 'minimal',
                relative = 'cursor',
                row = 0,
                col = 1,
            },
        })
    end,
}
