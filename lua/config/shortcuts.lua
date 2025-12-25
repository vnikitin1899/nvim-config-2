-- Пользовательские маппинги

local function require_with_lazy(plugin, module)
    module = module or plugin
    local ok, mod = pcall(require, module)
    if ok then
        return mod
    end
    local lazy_ok, lazy_mod = pcall(require, 'lazy')
    if lazy_ok then
        pcall(lazy_mod.load, { plugins = { plugin } })
    end
    ok, mod = pcall(require, module)
    if ok then
        return mod
    end
    vim.notify(string.format('Не удалось загрузить %s: %s', module, mod), vim.log.levels.ERROR)
    return nil
end

local function execute_neo_tree(opts)
    local command = require_with_lazy('neo-tree.nvim', 'neo-tree.command')
    if not command then
        return
    end
    command.execute(opts or {})
end

-- Быстрое открытие памятки по горячим клавишам
local function open_keymap_help()
    local keymap_file = vim.fn.stdpath('config') .. '/KEYBINDINGS.md'
    if vim.fn.filereadable(keymap_file) == 0 then
        vim.notify('Файл KEYBINDINGS.md не найден', vim.log.levels.WARN)
        return
    end

    local glow = require_with_lazy('glow.nvim', 'glow')
    local ok = false
    if glow then
        ok = pcall(function()
            vim.cmd('Glow ' .. vim.fn.fnameescape(keymap_file))
        end)
    end

    if not ok then
        vim.cmd('tabnew ' .. vim.fn.fnameescape(keymap_file))
    end
end

vim.api.nvim_create_user_command('KeymapHelp', open_keymap_help, {
    desc = 'Открыть памятку по горячим клавишам',
})

vim.keymap.set('n', '<leader>hk', open_keymap_help, { desc = 'Keymap help (Glow/tab)' })

-- Навигация по сплит окнам
vim.keymap.set('n', 'wh', '<C-w>h', { desc = 'Navigate to left window' })
vim.keymap.set('n', 'wl', '<C-w>l', { desc = 'Navigate to right window' })
vim.keymap.set('n', 'wj', '<C-w>j', { desc = 'Navigate to bottom window' })
vim.keymap.set('n', 'wk', '<C-w>k', { desc = 'Navigate to top window' })

-- Дерево файлов Neo-tree
vim.keymap.set('n', '<leader>e', function()
    vim.cmd('Neotree')
end, { desc = 'Neo-tree: Open explorer' })

vim.keymap.set('n', '<leader>ef', function()
    execute_neo_tree({
        reveal = true,
        source = 'filesystem',
        position = 'left',
        reveal_force_cwd = true,
    })
end, { desc = 'Neo-tree: Reveal current file' })

vim.keymap.set('n', '<leader>ec', function()
    execute_neo_tree({ action = 'close' })
end, { desc = 'Neo-tree: Close explorer' })

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

-- Быстрое включение/выключение treesitter контекста при необходимости
vim.keymap.set('n', '<leader>uc', function()
    require('treesitter-context').toggle()
end, { desc = 'Treesitter Context: Toggle' })

-- Spectre: глобальный поиск/замена
vim.keymap.set('n', 'ss', function()
    local spectre = require_with_lazy('nvim-spectre', 'spectre')
    if not spectre then
        return
    end
    spectre.open()
end, { desc = 'Spectre: Search project' })

vim.keymap.set('n', '<leader>sw', function()
    local spectre = require_with_lazy('nvim-spectre', 'spectre')
    if not spectre then
        return
    end
    spectre.open_visual({ select_word = true })
end, { desc = 'Spectre: Search current word' })

vim.keymap.set('v', '<leader>sw', function()
    local spectre = require_with_lazy('nvim-spectre', 'spectre')
    if not spectre then
        return
    end
    spectre.open_visual()
end, { desc = 'Spectre: Search selection' })

-- Форматирование кода через Conform
vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
    local conform = require_with_lazy('conform.nvim', 'conform')
    if not conform then
        return
    end
    conform.format({
        lsp_fallback = true,
        timeout_ms = 3000,
    })
end, { desc = 'Conform: Format buffer' })

-- Silicon: делаем снимок выделения / буфера
vim.keymap.set('v', '<leader>ss', function()
    if not require_with_lazy('silicon.nvim', 'silicon') then
        return
    end
    local ok, err = pcall(function()
        vim.cmd("'<,'>Silicon")
    end)
    if not ok then
        vim.notify('Silicon ошибка: ' .. tostring(err), vim.log.levels.ERROR)
    end
end, { desc = 'Silicon: Snapshot selection' })

vim.keymap.set('n', '<leader>sb', function()
    if not require_with_lazy('silicon.nvim', 'silicon') then
        return
    end
    local ok, err = pcall(function()
        vim.cmd('Silicon!')
    end)
    if not ok then
        vim.notify('Silicon ошибка: ' .. tostring(err), vim.log.levels.ERROR)
    end
end, { desc = 'Silicon: Snapshot buffer to clipboard' })
-- Быстрое открытие LazyGit
local function open_lazygit()
    local ok, err = pcall(vim.cmd, 'LazyGit')
    if not ok then
        vim.notify('LazyGit недоступен: ' .. tostring(err), vim.log.levels.ERROR)
    end
end

vim.keymap.set('n', '<leader>gd', open_lazygit, { desc = 'LazyGit: Open dashboard' })

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

-- Открытие LazyGit по комбинации "git"
vim.keymap.set('n', 'git', open_lazygit, { desc = 'LazyGit: Quick open' })
