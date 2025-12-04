return {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('diffview').setup({
            diff_binaries = false,
            enhanced_diff_hl = false,
            use_icons = true,
            show_help_hints = true,
            watch_index = true,
            view = {
                default = {
                    layout = 'diff2_horizontal',
                },
            },
            file_panel = {
                listing_style = 'tree',
                tree_options = {
                    flatten_dirs = true,
                    folder_statuses = 'only_folded',
                },
                win_config = {
                    position = 'left',
                    width = 35,
                },
            },
            file_history_panel = {
                win_config = {
                    position = 'left',
                    width = 35,
                },
            },
        })
    end,
}
