return {
    'nvim-pack/nvim-spectre',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
        color_devicons = true,
        live_update = true,
        highlight = {
            ui = 'String',
            search = 'DiffDelete',
            replace = 'DiffAdd',
        },
        mapping = {
            ['toggle_line'] = {
                map = 'dd',
                cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
                desc = 'Toggle current entry',
            },
            ['enter_file'] = {
                map = '<CR>',
                cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
                desc = 'Open file from result',
            },
            ['send_to_qf'] = {
                map = 'qo',
                cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
                desc = 'Send results to quickfix',
            },
            ['replace_cmd'] = {
                map = 'rc',
                cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
                desc = 'Use replace command',
            },
        },
    },
    config = function(_, opts)
        require('spectre').setup(opts)
    end,
}
