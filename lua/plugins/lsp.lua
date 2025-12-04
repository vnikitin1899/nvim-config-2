return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
        config = function()
            -- Защита от повторной загрузки конфигурации
            if vim.g.lsp_config_loaded then
                return
            end
            vim.g.lsp_config_loaded = true
            
            -- Настройка LSP
            local lspconfig = require('lspconfig')
            
            -- Базовые capabilities для LSP
            -- Используем улучшенные capabilities через nvim-cmp
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            

            -- Функция для установки маппингов
            local function setup_keymaps(bufnr)
                local opts = { buffer = bufnr, noremap = true, silent = true }
                
                -- gd - переход к определению с моментальным переходом к первому результату
                vim.keymap.set('n', 'gd', function()
                    -- Сохраняем оригинальный обработчик
                    local original_handler = vim.lsp.handlers['textDocument/definition']
                    
                    -- Временно переопределяем обработчик для моментального перехода
                    vim.lsp.handlers['textDocument/definition'] = function(err, result, ctx, config)
                        if err then
                            vim.notify('Ошибка: ' .. (err.message or tostring(err)), vim.log.levels.ERROR)
                            vim.lsp.handlers['textDocument/definition'] = original_handler
                            return
                        end
                        if not result or vim.tbl_isempty(result) then
                            vim.notify('Определение не найдено', vim.log.levels.INFO)
                            vim.lsp.handlers['textDocument/definition'] = original_handler
                            return
                        end
                        -- Моментальный переход к первому определению
                        local location = result[1]
                        if location.uri then
                            vim.lsp.util.jump_to_location(location, 'utf-16', false)
                        end
                        -- Восстанавливаем обработчик
                        vim.lsp.handlers['textDocument/definition'] = original_handler
                    end
                    
                    -- Вызываем стандартную функцию
                    vim.lsp.buf.definition()
                end, vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
            end

            -- Базовые маппинги для LSP
            local on_attach = function(client, bufnr)
                -- Отключение форматирования через ts_ls (если используется другой форматтер)
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false

                -- Маппинги для работы с диагностикой
                local opts = { buffer = bufnr, noremap = true, silent = true }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
                setup_keymaps(bufnr)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover documentation' }))
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = 'Go to implementation' }))
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'Signature help' }))
                -- Переход к предыдущей/следующей диагностике с автоматическим показом информации
                vim.keymap.set('n', '[d', function()
                    vim.diagnostic.goto_prev()
                    vim.diagnostic.open_float(nil, {
                        focus = false,
                        scope = 'cursor',
                        source = 'always',
                        border = 'rounded',
                    })
                end, vim.tbl_extend('force', opts, { desc = 'Previous diagnostic' }))
                vim.keymap.set('n', ']d', function()
                    vim.diagnostic.goto_next()
                    vim.diagnostic.open_float(nil, {
                        focus = false,
                        scope = 'cursor',
                        source = 'always',
                        border = 'rounded',
                    })
                end, vim.tbl_extend('force', opts, { desc = 'Next diagnostic' }))
                -- Показать полную информацию об ошибке в floating window
                vim.keymap.set('n', 'gl', function()
                    vim.diagnostic.open_float(nil, {
                        focus = false,
                        scope = 'cursor',
                        source = 'always',
                        border = 'rounded',
                    })
                end, vim.tbl_extend('force', opts, { desc = 'Show diagnostic details' }))
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code action' }))
            end

            -- Настройка TypeScript Language Server
            local ts_ls_config = {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = 'all',
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                },
            }

            -- Настройка диагностики с новым способом определения знаков
            -- Настраиваем один раз, до установки обработчика диагностик
            -- Убираем numhl из знаков, так как используем extmarks для подсветки номеров строк
            vim.diagnostic.config({
                virtual_text = {
                    enabled = true,
                    source = false,
                    prefix = '',
                    suffix = '',
                },
                signs = {
                    Error = { text = '󰅚 ' },
                    Warn = { text = '󰀪 ' },
                    Hint = { text = '󰌶 ' },
                    Info = { text = '󰋽 ' },
                },
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })

            -- Обработчик для фильтрации дублированных диагностик на уровне LSP
            -- Устанавливаем один раз, до настройки серверов
            local diagnostic_handler_set = false
            if not diagnostic_handler_set then
                diagnostic_handler_set = true
                local original_handler = vim.lsp.diagnostic.on_publish_diagnostics
                vim.lsp.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
                    if result and result.diagnostics then
                        local seen = {}
                        local filtered = {}
                        
                        for _, diag in ipairs(result.diagnostics) do
                            -- Создаем уникальный ключ на основе позиции, сообщения и severity
                            local key = string.format('%d:%d:%s:%d', 
                                diag.range.start.line, 
                                diag.range.start.character, 
                                diag.message, 
                                diag.severity
                            )
                            
                            -- Фильтруем дубликаты в текущем наборе диагностик
                            if not seen[key] then
                                seen[key] = true
                                table.insert(filtered, diag)
                            end
                        end
                        
                        result.diagnostics = filtered
                    end
                    
                    -- Вызываем стандартный обработчик с отфильтрованными диагностиками
                    original_handler(err, result, ctx, config)
                end
            end

            -- Автоматическая установка маппингов при подключении LSP
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client and client.name == 'ts_ls' then
                        setup_keymaps(bufnr)
                    end
                end,
            })

            -- Настройка Mason LSP Config
            -- Настраиваем ts_ls только через обработчик, чтобы избежать дублирования
            require('mason-lspconfig').setup({
                ensure_installed = { 'ts_ls' },
                automatic_installation = true,
                handlers = {
                    ts_ls = function()
                        -- Проверяем, что сервер еще не настроен
                        if not vim.g.ts_ls_setup_done then
                            vim.g.ts_ls_setup_done = true
                            lspconfig.ts_ls.setup(ts_ls_config)
                        end
                    end,
                },
            })
            
            -- Подсветка номеров строк через extmarks
            local numhl_ns = vim.api.nvim_create_namespace('diagnostic_numhl')
            vim.api.nvim_create_autocmd({ 'DiagnosticChanged', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
                callback = function()
                    local bufnr = vim.api.nvim_get_current_buf()
                    vim.api.nvim_buf_clear_namespace(bufnr, numhl_ns, 0, -1)
                    local diagnostics = vim.diagnostic.get(bufnr)
                    -- Фильтруем дублированные диагностики по позиции и сообщению
                    local seen = {}
                    local unique_diagnostics = {}
                    for _, diag in ipairs(diagnostics) do
                        local key = string.format('%d:%d:%s', diag.lnum, diag.col, diag.message)
                        if not seen[key] then
                            seen[key] = true
                            table.insert(unique_diagnostics, diag)
                        end
                    end
                    for _, diag in ipairs(unique_diagnostics) do
                        local line = diag.lnum
                        local severity = diag.severity
                        local hl_group = ''
                        if severity == vim.diagnostic.severity.ERROR then
                            hl_group = 'DiagnosticErrorNr'
                        elseif severity == vim.diagnostic.severity.WARN then
                            hl_group = 'DiagnosticWarnNr'
                        elseif severity == vim.diagnostic.severity.HINT then
                            hl_group = 'DiagnosticHintNr'
                        elseif severity == vim.diagnostic.severity.INFO then
                            hl_group = 'DiagnosticInfoNr'
                        end
                        if hl_group ~= '' then
                            vim.api.nvim_buf_set_extmark(bufnr, numhl_ns, line, 0, {
                                number_hl_group = hl_group,
                                priority = 1000,
                            })
                        end
                    end
                end,
            })

            -- Настройка цветов для номеров строк с диагностикой
            vim.api.nvim_set_hl(0, 'DiagnosticErrorNr', { fg = '#ff6767', bg = 'NONE', bold = true })
            vim.api.nvim_set_hl(0, 'DiagnosticWarnNr', { fg = '#ffca85', bg = 'NONE', bold = true })
            vim.api.nvim_set_hl(0, 'DiagnosticHintNr', { fg = '#82e2ff', bg = 'NONE', bold = true })
            vim.api.nvim_set_hl(0, 'DiagnosticInfoNr', { fg = '#61ffca', bg = 'NONE', bold = true })

            -- Автоматическое применение цветов после загрузки цветовой схемы
            vim.api.nvim_create_autocmd({ 'ColorScheme', 'BufEnter' }, {
                callback = function()
                    vim.api.nvim_set_hl(0, 'DiagnosticErrorNr', { fg = '#ff6767', bg = 'NONE', bold = true })
                    vim.api.nvim_set_hl(0, 'DiagnosticWarnNr', { fg = '#ffca85', bg = 'NONE', bold = true })
                    vim.api.nvim_set_hl(0, 'DiagnosticHintNr', { fg = '#82e2ff', bg = 'NONE', bold = true })
                    vim.api.nvim_set_hl(0, 'DiagnosticInfoNr', { fg = '#61ffca', bg = 'NONE', bold = true })
                end,
            })
        end,
    },
}
