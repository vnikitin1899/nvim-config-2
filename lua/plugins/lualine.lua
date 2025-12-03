return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local lualine = require('lualine')

        local conditions = {
            buffer_not_empty = function()
                return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
            end,
            hide_in_width = function()
                return vim.fn.winwidth(0) > 80
            end,
            check_git_workspace = function()
                local filepath = vim.fn.expand('%:p:h')
                local gitdir = vim.fn.finddir('.git', filepath .. ';')
                return gitdir and #gitdir > 0 and #gitdir < #filepath
            end,
        }

        -- Конфигурация статус бара
        local config = {
            options = {
                component_separators = '',
                section_separators = '',
                disabled_filetypes = { 'alpha', 'dashboard', 'NvimTree', 'Outline' },
                always_divide_middle = true,
                theme = {
                    normal = {
                        a = { fg = '#edecee', bg = '#a277ff', gui = 'bold' },
                        b = { fg = '#edecee', bg = '#6d4a9e' },
                        c = { fg = '#edecee', bg = '#15141b' },
                        x = { fg = '#edecee', bg = '#15141b' },
                        y = { fg = '#edecee', bg = '#15141b' },
                        z = { fg = '#edecee', bg = '#15141b' },
                    },
                    insert = {
                        a = { fg = '#edecee', bg = '#61ffca', gui = 'bold' },
                        b = { fg = '#edecee', bg = '#6d4a9e' },
                        c = { fg = '#edecee', bg = '#15141b' },
                    },
                    visual = {
                        a = { fg = '#15141b', bg = '#ffca85', gui = 'bold' },
                        b = { fg = '#edecee', bg = '#6d4a9e' },
                        c = { fg = '#edecee', bg = '#15141b' },
                    },
                    replace = {
                        a = { fg = '#edecee', bg = '#ff6767', gui = 'bold' },
                        b = { fg = '#edecee', bg = '#6d4a9e' },
                        c = { fg = '#edecee', bg = '#15141b' },
                    },
                    command = {
                        a = { fg = '#15141b', bg = '#82e2ff', gui = 'bold' },
                        b = { fg = '#edecee', bg = '#6d4a9e' },
                        c = { fg = '#edecee', bg = '#15141b' },
                    },
                    inactive = {
                        a = { fg = '#6d6d6d', bg = '#15141b' },
                        b = { fg = '#6d6d6d', bg = '#15141b' },
                        c = { fg = '#6d6d6d', bg = '#15141b' },
                        x = { fg = '#6d6d6d', bg = '#15141b' },
                        y = { fg = '#6d6d6d', bg = '#15141b' },
                        z = { fg = '#6d6d6d', bg = '#15141b' },
                    },
                },
            },
            tabline = {
                lualine_a = {
                    {
                        'filename',
                        path = 1,
                        symbols = {
                            modified = ' ●',
                            readonly = ' 󰈡',
                            unnamed = '󰈔',
                            newfile = ' 󰎔',
                        },
                        color = { fg = '#61ffca', bg = 'NONE' },
                        padding = { left = 1, right = 1 },
                        fmt = function(str)
                            return '\n' .. str
                        end,
                    },
                },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
            sections = {
                -- Левая секция
                lualine_a = {
                    {
                        'mode',
                        icon = '',
                        separator = { left = '', right = '│' },
                        padding = { left = 0, right = 1 },
                    },
                },
                lualine_b = {
                    {
                        'branch',
                        icon = '󰘬',
                        condition = conditions.check_git_workspace,
                        separator = { left = '', right = '│' },
                        padding = { left = 1, right = 1 },
                    },
                    {
                        'diff',
                        symbols = { added = '󰐕 ', modified = '󰏫 ', removed = '󰍴 ' },
                        condition = conditions.hide_in_width,
                        separator = { left = '', right = '│' },
                        padding = { left = 1, right = 1 },
                    },
                },
                lualine_c = {},
                -- Правая секция
                lualine_x = {
                    {
                        'diagnostics',
                        sources = { 'nvim_diagnostic' },
                        symbols = { error = '󰅚 ', warn = '󰀪 ', info = '󰋽 ', hint = '󰌶 ' },
                        separator = { left = '', right = '│' },
                        padding = { left = 1, right = 1 },
                    },
                    {
                        'filetype',
                        icon_only = false,
                        separator = { left = '', right = '│' },
                        padding = { left = 1, right = 1 },
                    },
                },
                lualine_y = {
                    {
                        'location',
                        separator = { left = '', right = '│' },
                        padding = { left = 1, right = 1 },
                    },
                },
                lualine_z = {
                    {
                        'progress',
                        separator = { left = '│', right = '' },
                        padding = { left = 1, right = 0 },
                    },
                },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {},
            },
            extensions = {},
        }

        lualine.setup(config)
        
        -- Настройка цветов tabline напрямую через hl_groups
        vim.api.nvim_set_hl(0, 'TabLineFill', { bg = 'NONE' })
        vim.api.nvim_set_hl(0, 'TabLine', { fg = '#61ffca', bg = 'NONE' })
        vim.api.nvim_set_hl(0, 'TabLineSel', { fg = '#61ffca', bg = 'NONE', bold = true })
        
        -- Автоматическое применение цветов после загрузки
        vim.api.nvim_create_autocmd({ 'ColorScheme', 'BufEnter', 'WinEnter' }, {
            callback = function()
                vim.api.nvim_set_hl(0, 'TabLineFill', { bg = 'NONE' })
                vim.api.nvim_set_hl(0, 'TabLine', { fg = '#61ffca', bg = 'NONE' })
                vim.api.nvim_set_hl(0, 'TabLineSel', { fg = '#61ffca', bg = 'NONE', bold = true })
            end,
        })
        
    end,
}
