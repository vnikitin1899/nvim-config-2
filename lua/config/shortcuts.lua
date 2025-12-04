-- Пользовательские маппинги

-- Навигация по сплит окнам
vim.keymap.set('n', 'wh', '<C-w>h', { desc = 'Navigate to left window' })
vim.keymap.set('n', 'wl', '<C-w>l', { desc = 'Navigate to right window' })
vim.keymap.set('n', 'wj', '<C-w>j', { desc = 'Navigate to bottom window' })
vim.keymap.set('n', 'wk', '<C-w>k', { desc = 'Navigate to top window' })

-- Открытие Telescope для поиска файлов по ff
vim.keymap.set('n', 'ff', function()
    require('telescope.builtin').find_files({
        layout_strategy = 'flex',
        layout_config = {
            flex = {
                flip_columns = 120,
            },
            horizontal = {
                preview_width = 0.5,
                preview_cutoff = 120,
            },
            vertical = {
                preview_height = 0.5,
            },
            width = 0.9,
            height = 0.9,
            prompt_position = 'bottom',
        },
        preview = {
            enabled = true,
            hide_on_startup = false,
        },
    })
end, { desc = 'Telescope: Find files' })

-- Открытие Telescope для поиска слов среди файлов по fg (без node_modules)
vim.keymap.set('n', 'fg', function()
    require('telescope.builtin').live_grep({
        layout_strategy = 'vertical',
        layout_config = {
            vertical = {
                width = 0.9,
                height = 0.9,
                preview_height = 0.4,
                preview_cutoff = 1,
                mirror = true,
            },
            prompt_position = 'bottom',
        },
        preview = {
            enabled = true,
            hide_on_startup = false,
        },
        path_display = { 'truncate' },
        -- Исключаем node_modules по умолчанию
        additional_args = function(opts)
            return { '--glob=!node_modules/**' }
        end,
    })
end, { desc = 'Telescope: Live grep (search words in files)' })

-- Открытие Telescope для поиска слов среди файлов включая node_modules по <leader>fg
vim.keymap.set('n', '<leader>fg', function()
    require('telescope.builtin').live_grep({
        layout_strategy = 'vertical',
        layout_config = {
            vertical = {
                width = 0.9,
                height = 0.9,
                preview_height = 0.4,
                preview_cutoff = 1,
                mirror = true,
            },
            prompt_position = 'bottom',
        },
        preview = {
            enabled = true,
            hide_on_startup = false,
        },
        path_display = { 'truncate' },
        -- Включаем node_modules в поиск - игнорируем .gitignore
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--no-ignore',  -- Игнорируем .gitignore и другие файлы игнорирования
        },
    })
end, { desc = 'Telescope: Live grep including node_modules' })

-- Открытие Telescope для поиска слов среди файлов включая node_modules по ag
vim.keymap.set('n', 'ag', function()
    require('telescope.builtin').live_grep({
        layout_strategy = 'vertical',
        layout_config = {
            vertical = {
                width = 0.9,
                height = 0.9,
                preview_height = 0.4,
                preview_cutoff = 1,
                mirror = true,
            },
            prompt_position = 'bottom',
        },
        preview = {
            enabled = true,
            hide_on_startup = false,
        },
        path_display = { 'truncate' },
        -- Включаем node_modules в поиск - игнорируем .gitignore
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--no-ignore',  -- Игнорируем .gitignore и другие файлы игнорирования
        },
    })
end, { desc = 'Telescope: Live grep including node_modules' })

-- Функция для открытия панели git diff
local function open_git_diff_panel(hide_headers)
    -- Настройки кастомного режима
    local config = {
        file_panel_width = 40,  -- Ширина панели файлов
        show_headers = not hide_headers,  -- Показывать заголовки git diff (скрывать если hide_headers = true)
        highlight_context = true, -- Подсвечивать контекстные строки
    }
    
    -- Получаем список измененных файлов
    local files_output = vim.fn.system('git diff --name-only')
    if vim.v.shell_error ~= 0 or files_output == '' then
        vim.notify('Нет изменений для отображения', vim.log.levels.INFO)
        return
    end
    
    local files = vim.split(files_output:gsub('\n$', ''), '\n')
    local current_file_index = 1  -- Текущий выбранный файл
    
    -- Создаем буфер для панели файлов
    local file_panel_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(file_panel_buf, 'git-diff-files')
    vim.api.nvim_buf_set_option(file_panel_buf, 'filetype', 'git-diff-files')
    vim.api.nvim_buf_set_option(file_panel_buf, 'modifiable', true)
    
    -- Функция для обновления списка файлов с выделением текущего
    local function update_file_list()
        local lines = { '=== Измененные файлы ===', '' }
        for i, file in ipairs(files) do
            local marker = (i == current_file_index) and '▶ ' or '  '
            table.insert(lines, string.format('%s%d. %s', marker, i, file))
        end
        vim.api.nvim_buf_set_option(file_panel_buf, 'modifiable', true)
        vim.api.nvim_buf_set_lines(file_panel_buf, 0, -1, false, lines)
        vim.api.nvim_buf_set_option(file_panel_buf, 'modifiable', false)
    end
    
    update_file_list()
    
    -- Создаем буфер для unified diff
    local diff_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(diff_buf, 'git-diff-unified')
    vim.api.nvim_buf_set_option(diff_buf, 'filetype', 'diff')
    vim.api.nvim_buf_set_option(diff_buf, 'modifiable', true)
    vim.api.nvim_buf_set_option(diff_buf, 'syntax', 'diff')
    
    -- Получаем unified diff для файла
    local function show_diff(file_index)
        if file_index < 1 or file_index > #files then
            return
        end
        current_file_index = file_index
        update_file_list()
        
        local file = files[file_index]
        local diff_output = vim.fn.system('git diff ' .. vim.fn.shellescape(file))
        if vim.v.shell_error == 0 then
            vim.api.nvim_buf_set_option(diff_buf, 'modifiable', true)
            local all_lines = vim.split(diff_output, '\n')
            
            local diff_lines = {}
            for _, line in ipairs(all_lines) do
                local is_header = line:match('^diff --git') 
                              or line:match('^index ') 
                              or line:match('^--- a/')
                              or line:match('^+++ b/')
                              or line:match('^@@')
                
                if config.show_headers or not is_header then
                    if not is_header then
                        table.insert(diff_lines, line)
                    elseif config.show_headers and is_header then
                        table.insert(diff_lines, line)
                    end
                end
            end
            
            vim.api.nvim_buf_set_lines(diff_buf, 0, -1, false, diff_lines)
            vim.api.nvim_buf_set_option(diff_buf, 'modifiable', false)
            
            -- Применяем подсветку
            vim.api.nvim_buf_clear_namespace(diff_buf, vim.api.nvim_create_namespace('diff_highlight'), 0, -1)
            local ns = vim.api.nvim_create_namespace('diff_highlight')
            
            for i, line in ipairs(diff_lines) do
                local first_char = line:sub(1, 1)
                if first_char == '+' then
                    vim.api.nvim_buf_add_highlight(diff_buf, ns, 'DiffAdd', i - 1, 0, -1)
                elseif first_char == '-' then
                    vim.api.nvim_buf_add_highlight(diff_buf, ns, 'DiffDelete', i - 1, 0, -1)
                elseif config.highlight_context and first_char == ' ' then
                    -- Подсветка контекстных строк (опционально)
                    vim.api.nvim_buf_add_highlight(diff_buf, ns, 'DiffText', i - 1, 0, -1)
                end
            end
        end
    end
    
    -- Показываем diff для первого файла
    show_diff(1)
    
    -- Создаем split окна
    vim.cmd('vsplit')
    local file_panel_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(file_panel_win, file_panel_buf)
    vim.api.nvim_win_set_width(file_panel_win, config.file_panel_width)
    
    vim.cmd('wincmd l')
    local diff_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(diff_win, diff_buf)
    
    -- Маппинги для панели файлов
    vim.api.nvim_buf_set_keymap(file_panel_buf, 'n', '<CR>', '', {
        callback = function()
            local line = vim.api.nvim_get_current_line()
            local file_num = tonumber(line:match('(%d+)%.'))
            if file_num then
                show_diff(file_num)
                vim.api.nvim_set_current_win(diff_win)
            end
        end,
    })
    
    vim.api.nvim_buf_set_keymap(file_panel_buf, 'n', 'j', '', {
        callback = function()
            if current_file_index < #files then
                show_diff(current_file_index + 1)
            end
        end,
    })
    
    vim.api.nvim_buf_set_keymap(file_panel_buf, 'n', 'k', '', {
        callback = function()
            if current_file_index > 1 then
                show_diff(current_file_index - 1)
            end
        end,
    })
    
    -- Маппинги для diff буфера
    vim.api.nvim_buf_set_keymap(diff_buf, 'n', 'j', '', {
        callback = function()
            if current_file_index < #files then
                show_diff(current_file_index + 1)
                vim.api.nvim_set_current_win(file_panel_win)
            end
        end,
    })
    
    vim.api.nvim_buf_set_keymap(diff_buf, 'n', 'k', '', {
        callback = function()
            if current_file_index > 1 then
                show_diff(current_file_index - 1)
                vim.api.nvim_set_current_win(file_panel_win)
            end
        end,
    })
    
    -- Маппинг для закрытия панели
    local function close_panel()
        vim.api.nvim_buf_delete(file_panel_buf, { force = true })
        vim.api.nvim_buf_delete(diff_buf, { force = true })
    end
    
    vim.api.nvim_buf_set_keymap(file_panel_buf, 'n', 'q', '', {
        callback = close_panel,
    })
    vim.api.nvim_buf_set_keymap(diff_buf, 'n', 'q', '', {
        callback = close_panel,
    })
    
    -- Переходим в панель файлов
    vim.api.nvim_set_current_win(file_panel_win)
end

-- Открытие панели git diff: список файлов слева, unified diff справа в одном окне
vim.keymap.set('n', '<leader>gd', function()
    open_git_diff_panel(false)  -- Показывать заголовки
end, { desc = 'Git diff: Panel with unified diff' })

-- Открытие Diffview для просмотра всех изменений
vim.keymap.set('n', '<leader>gv', function()
    vim.cmd('DiffviewOpen')
end, { desc = 'Diffview: Open diff view' })

-- Открытие Diffview для истории файла
vim.keymap.set('n', '<leader>gh', function()
    require('diffview').file_history()
end, { desc = 'Diffview: Open file history' })

-- Закрытие Diffview
vim.keymap.set('n', '<leader>gq', function()
    require('diffview').close()
end, { desc = 'Diffview: Close' })

-- Открытие git diff по комбинации "git" (без заголовков)
vim.keymap.set('n', 'git', function()
    open_git_diff_panel(true)  -- Скрывать заголовки
end, { desc = 'Git diff: Open git diff panel (no headers)' })
