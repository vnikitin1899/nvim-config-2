return {
    'akinsho/git-conflict.nvim',
    version = '*',
    event = 'BufReadPost',
    config = function()
        local ok, conflict = pcall(require, 'git-conflict')
        if not ok then
            return
        end

        conflict.setup({
            default_mappings = true,
            disable_diagnostics = false,
            highlights = {
                current = 'DiffText',
                incoming = 'DiffAdd',
                ancestor = 'DiffChange',
            },
        })

        vim.keymap.set('n', '<leader>gx', '<Cmd>GitConflictRefresh<CR>', {
            desc = 'Перезагрузить маркировку конфликтов',
        })
    end,
}
