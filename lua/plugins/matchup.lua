return {
    'andymass/vim-matchup',
    init = function()
        vim.g.matchup_matchparen_offscreen = { method = 'popup' }
        vim.g.matchup_matchparen_deferred = 1
        vim.g.matchup_matchparen_deferred_show_delay = 150
        vim.g.matchup_matchparen_deferred_hide_delay = 700
        vim.g.matchup_matchparen_hi_surround_always = 1
        vim.g.matchup_matchparen_enabled = 1
        vim.g.matchup_delim_noskips = 1
    end,
    config = function()
        -- Подсветка парных скобок
        vim.api.nvim_set_hl(0, 'MatchParen', { fg = '#a277ff', bg = '#1e1d2e', bold = true, underline = true })
        vim.api.nvim_set_hl(0, 'MatchWord', { fg = '#61ffca', bg = '#1e3a1e', bold = true })
        vim.api.nvim_set_hl(0, 'MatchParenCur', { fg = '#a277ff', bg = '#1e1d2e', bold = true, underline = true })
        vim.api.nvim_set_hl(0, 'MatchWordCur', { fg = '#61ffca', bg = '#1e3a1e', bold = true })
        
        vim.api.nvim_create_autocmd('ColorScheme', {
            callback = function()
                vim.api.nvim_set_hl(0, 'MatchParen', { fg = '#a277ff', bg = '#1e1d2e', bold = true, underline = true })
                vim.api.nvim_set_hl(0, 'MatchWord', { fg = '#61ffca', bg = '#1e3a1e', bold = true })
                vim.api.nvim_set_hl(0, 'MatchParenCur', { fg = '#a277ff', bg = '#1e1d2e', bold = true, underline = true })
                vim.api.nvim_set_hl(0, 'MatchWordCur', { fg = '#61ffca', bg = '#1e3a1e', bold = true })
            end,
        })
    end,
}
