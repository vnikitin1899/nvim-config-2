local function detect_font()
    local fonts = {
        'JetBrainsMono Nerd Font',
        'FiraCode Nerd Font',
        'Menlo',
        'Monaco',
    }
    local font_dirs = {
        '/System/Library/Fonts',
        '/Library/Fonts',
        os.getenv('HOME') .. '/Library/Fonts',
        '/usr/share/fonts',
        '/usr/local/share/fonts',
    }
    for _, font in ipairs(fonts) do
        for _, dir in ipairs(font_dirs) do
            local pattern = string.format('%s/%s*.ttf', dir, font)
            local matches = vim.fn.glob(pattern, false, true)
            if matches and #matches > 0 then
                return font .. '=18'
            end
        end
    end
    return nil
end

local function ensure_output_path()
    local desktop = vim.fn.expand('~/Desktop')
    local dir = desktop .. '/silicon_shots'
    vim.fn.mkdir(dir, 'p')
    return dir
end

return {
    'krivahtoo/silicon.nvim',
    cmd = 'Silicon',
    build = './install.sh',
    opts = {
        theme = 'Monokai Extended',
        background = '#1e1b2b',
        font = detect_font(),
        line_numbers = true,
        pad_horiz = 32,
        pad_vert = 32,
        shadow = {
            blur_radius = 12,
            offset_x = 0,
            offset_y = 0,
            color = '#00000080',
        },
        output = {
            path = ensure_output_path(),
            format = 'screenshot_[year][month][day]-[hour][minute][second].png',
            clipboard = false,
        },
    },
    config = function(_, opts)
        require('silicon').setup(opts)
    end,
}
