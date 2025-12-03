return {
    dir = vim.fn.expand('~/aura-theme'),
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd([[colorscheme aura-dark]])
    end,
}
