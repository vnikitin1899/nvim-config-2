return {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
    },
    cmd = { 'Neotree' },
    init = function()
        vim.g.neo_tree_remove_legacy_commands = 1
    end,
    config = function()
        local ok, neo_tree = pcall(require, 'neo-tree')
        if not ok then
            return
        end
        local neo_tree_command = require('neo-tree.command')

        neo_tree.setup({
            close_if_last_window = true,
            popup_border_style = 'rounded',
            enable_git_status = true,
            enable_diagnostics = true,
            source_selector = {
                winbar = true,
                content_layout = 'center',
            },
            default_component_configs = {
                indent = {
                    padding = 1,
                    with_expanders = true,
                },
                git_status = {
                    symbols = {
                        added = '',
                        modified = '',
                        deleted = '',
                        renamed = '',
                        untracked = '',
                        ignored = '',
                        unstaged = '󰄱',
                        staged = '',
                        conflict = '',
                    },
                },
            },
            event_handlers = {
                {
                    event = 'file_open_requested',
                    handler = function()
                        neo_tree_command.execute({ action = 'close' })
                    end,
                },
            },
            filesystem = {
                bind_to_cwd = true,
                follow_current_file = {
                    enabled = true,
                    leave_dirs_open = false,
                },
                group_empty_dirs = true,
                hijack_netrw_behavior = 'open_default',
                filtered_items = {
                    hide_dotfiles = false,
                    hide_gitignored = true,
                    hide_by_name = { '.DS_Store' },
                },
                window = {
                    position = 'current',
                    width = 34,
                    mappings = {
                        ['<space>'] = 'toggle_node',
                        ['l'] = 'open',
                        ['h'] = 'close_node',
                        ['<cr>'] = 'open',
                        ['H'] = 'toggle_hidden',
                        ['.'] = 'set_root',
                        ['P'] = { 'toggle_preview', config = { use_float = true } },
                        ['R'] = 'refresh',
                    },
                },
            },
        })
    end,
}
