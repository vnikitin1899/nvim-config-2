return {
    'nvim-treesitter/nvim-treesitter-context',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
        enable = true,
        max_lines = 3,
        trim_scope = 'outer',
        mode = 'cursor',
        separator = '-',
        multiline_threshold = 10,
        zindex = 20,
        on_attach = function(buf)
            -- Не включаем контекст на слишком больших файлах, чтобы избежать лагов
            local max_filesize = 200 * 1024
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return false
            end
        end,
    },
}
