-- Основные настройки Neovim

-- Номера строк
vim.opt.number = true
vim.opt.relativenumber = false

-- Дополнительные полезные настройки
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'line'
vim.opt.signcolumn = 'yes'
vim.opt.clipboard = 'unnamedplus'
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.autoread = true

-- Прячем стандартную командную строку: её заменит всплывающий cmdline
vim.opt.cmdheight = 0

-- Включить tabline для отображения имени файла вверху
vim.opt.showtabline = 2

-- Включить выделение парных скобок
vim.opt.showmatch = true
vim.opt.matchtime = 1

-- Автоматическое сохранение при выходе из Insert режима
vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
        local bufname = vim.api.nvim_buf_get_name(0)
        if vim.bo.modified and not vim.bo.readonly and bufname ~= '' then
            -- Проверяем, существует ли файл или это новый файл
            local file_exists = vim.fn.filereadable(bufname) == 1
            if file_exists then
                vim.cmd('silent write')
            else
                -- Для новых файлов используем принудительное сохранение
                vim.cmd('silent write!')
            end
        end
    end,
})

-- Проверяем изменения файлов на диске и обновляем буфер
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
    command = 'checktime',
    desc = 'Следить за изменениями файлов на диске',
})
