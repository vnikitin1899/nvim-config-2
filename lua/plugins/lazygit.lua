return {
    'kdheepak/lazygit.nvim',
    cmd = {
        'LazyGit',
        'LazyGitConfig',
        'LazyGitCurrentFile',
        'LazyGitFilter',
        'LazyGitFilterCurrentFile',
    },
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
    },
    init = function()
        vim.g.lazygit_floating_window_use_plenary = 0
        vim.g.lazygit_floating_window_scaling_factor = 0.95
        vim.g.lazygit_use_neovim_remote = 1

        local config_path = vim.fn.stdpath('config') .. '/lazygit/config.yml'
        vim.g.lazygit_use_custom_config_file_path = 1
        vim.g.lazygit_config_file_path = { config_path }
    end,
}
