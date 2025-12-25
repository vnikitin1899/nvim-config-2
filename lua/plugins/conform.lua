return {
    {
        'stevearc/conform.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        cmd = { 'ConformInfo' },
        config = function()
            local conform = require('conform')
            local formatters = require('conform.formatters')

            local disable_filetypes = {
                gitcommit = true,
                gitrebase = true,
                json = true,
                jsonc = true,
            }

            local prettier_filetypes = {
                javascript = true,
                javascriptreact = true,
                typescript = true,
                typescriptreact = true,
                css = true,
                scss = true,
                html = true,
                yaml = true,
                markdown = true,
            }

            local insert_group = vim.api.nvim_create_augroup('ConformInsertPrettier', { clear = true })

            local function get_buf_var(bufnr, name)
                local ok, value = pcall(vim.api.nvim_buf_get_var, bufnr, name)
                if ok then
                    return value
                end
                return nil
            end

            local function set_buf_var(bufnr, name, value)
                if value == nil then
                    pcall(vim.api.nvim_buf_del_var, bufnr, name)
                    return
                end
                vim.api.nvim_buf_set_var(bufnr, name, value)
            end

            local function prettier_enabled_for_buffer(bufnr)
                if vim.g.disable_autoformat or get_buf_var(bufnr, 'disable_autoformat') then
                    return false
                end
                if vim.g.disable_insert_prettier or get_buf_var(bufnr, 'disable_insert_prettier') then
                    return false
                end
                return true
            end

            local function should_run_prettier(bufnr)
                if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
                    return false
                end
                local ft = vim.bo[bufnr].filetype
                if ft == '' or not prettier_filetypes[ft] or disable_filetypes[ft] then
                    return false
                end
                if vim.bo[bufnr].buftype ~= '' or not vim.bo[bufnr].modifiable then
                    return false
                end
                if not prettier_enabled_for_buffer(bufnr) then
                    return false
                end
                local last_tick = get_buf_var(bufnr, 'prettier_last_tick')
                local current_tick = vim.api.nvim_buf_get_changedtick(bufnr)
                if last_tick ~= nil and last_tick == current_tick then
                    return false
                end
                return true
            end

            local function run_prettier(bufnr)
                conform.format({
                    bufnr = bufnr,
                    formatters = { 'prettierd', 'prettier' },
                    timeout_ms = 2000,
                    async = false,
                    lsp_fallback = false,
                })
                set_buf_var(bufnr, 'prettier_last_tick', vim.api.nvim_buf_get_changedtick(bufnr))
            end

            formatters.prettier_json = vim.tbl_deep_extend('force', {}, formatters.prettier or {}, {
                args = { '--parser', 'json', '--tab-width', '2', '--use-tabs', 'false' },
            })

            conform.setup({
                notify_on_error = true,
                formatters_by_ft = {
                    lua = { 'stylua' },
                    javascript = { 'prettierd', 'prettier' },
                    javascriptreact = { 'prettierd', 'prettier' },
                    typescript = { 'prettierd', 'prettier' },
                    typescriptreact = { 'prettierd', 'prettier' },
                    json = { 'prettier_json' },
                    jsonc = { 'prettier_json' },
                    css = { 'prettierd', 'prettier' },
                    scss = { 'prettierd', 'prettier' },
                    html = { 'prettierd', 'prettier' },
                    yaml = { 'prettierd', 'prettier' },
                    markdown = { 'prettier' },
                    ['_'] = { 'trim_whitespace' },
                },
                format_on_save = function(bufnr)
                    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                        return
                    end
                    local ft = vim.bo[bufnr].filetype
                    if disable_filetypes[ft] then
                        return
                    end
                    return { timeout_ms = 3000, lsp_fallback = true }
                end,
            })

            local function notify_state(state, scope)
                local target = scope == 'buffer' and 'буфере' or 'сессии'
                local message = state and 'Автоформатирование включено в ' .. target
                    or 'Автоформатирование отключено в ' .. target
                vim.notify(message, vim.log.levels.INFO)
            end

            vim.api.nvim_create_user_command('FormatDisable', function(opts)
                if opts.bang then
                    vim.b.disable_autoformat = true
                    notify_state(false, 'buffer')
                    return
                end
                vim.g.disable_autoformat = true
                notify_state(false, 'global')
            end, {
                desc = 'Отключить автоформатирование (используйте ! для текущего буфера)',
                bang = true,
            })

            vim.api.nvim_create_user_command('FormatEnable', function(opts)
                if opts.bang then
                    vim.b.disable_autoformat = false
                    notify_state(true, 'buffer')
                    return
                end
                vim.g.disable_autoformat = false
                notify_state(true, 'global')
            end, {
                desc = 'Включить автоформатирование (используйте ! для текущего буфера)',
                bang = true,
            })

            vim.api.nvim_create_user_command('FormatToggle', function(opts)
                if opts.bang then
                    vim.b.disable_autoformat = not vim.b.disable_autoformat
                    notify_state(not vim.b.disable_autoformat, 'buffer')
                    return
                end
                vim.g.disable_autoformat = not vim.g.disable_autoformat
                notify_state(not vim.g.disable_autoformat, 'global')
            end, {
                desc = 'Переключить автоформатирование (используйте ! для текущего буфера)',
                bang = true,
            })

            local function notify_insert_state(state, scope)
                local target = scope == 'buffer' and 'буфере' or 'сессии'
                local message = state and 'Prettier при выходе из Insert включен в ' .. target
                    or 'Prettier при выходе из Insert отключен в ' .. target
                vim.notify(message, vim.log.levels.INFO)
            end

            vim.api.nvim_create_user_command('FormatInsertDisable', function(opts)
                if opts.bang then
                    vim.b.disable_insert_prettier = true
                    notify_insert_state(false, 'buffer')
                    return
                end
                vim.g.disable_insert_prettier = true
                notify_insert_state(false, 'global')
            end, {
                desc = 'Отключить Prettier при выходе из Insert (используйте ! для буфера)',
                bang = true,
            })

            vim.api.nvim_create_user_command('FormatInsertEnable', function(opts)
                if opts.bang then
                    vim.b.disable_insert_prettier = false
                    notify_insert_state(true, 'buffer')
                    return
                end
                vim.g.disable_insert_prettier = false
                notify_insert_state(true, 'global')
            end, {
                desc = 'Включить Prettier при выходе из Insert (используйте ! для буфера)',
                bang = true,
            })

            vim.api.nvim_create_user_command('FormatInsertToggle', function(opts)
                if opts.bang then
                    vim.b.disable_insert_prettier = not vim.b.disable_insert_prettier
                    notify_insert_state(not vim.b.disable_insert_prettier, 'buffer')
                    return
                end
                vim.g.disable_insert_prettier = not vim.g.disable_insert_prettier
                notify_insert_state(not vim.g.disable_insert_prettier, 'global')
            end, {
                desc = 'Переключить Prettier при выходе из Insert (используйте ! для буфера)',
                bang = true,
            })

            vim.api.nvim_create_autocmd('InsertLeave', {
                group = insert_group,
                callback = function(args)
                    local bufnr = args.buf
                    if not should_run_prettier(bufnr) then
                        return
                    end
                    local ok, err = pcall(run_prettier, bufnr)
                    if not ok then
                        vim.notify('Prettier: ' .. tostring(err), vim.log.levels.WARN)
                    end
                end,
                desc = 'Форматирование Prettier при выходе из Insert',
            })
        end,
    },
}
