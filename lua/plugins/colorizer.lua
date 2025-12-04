return {
    'NvChad/nvim-colorizer.lua',
    config = function()
        require('colorizer').setup({
            filetypes = {
                'css',
                'scss',
                'sass',
                'less',
                'html',
                'javascript',
                'javascriptreact',
                'typescript',
                'typescriptreact',
                'lua',
            },
            user_default_options = {
                RGB = true,
                RRGGBB = true,
                names = true,
                RRGGBBAA = true,
                rgb_fn = false,
                hsl_fn = false,
                css = true,
                css_fn = false,
                mode = 'background',
                tailwind = false,
                sass = { enable = false, parsers = { 'css' } },
                virtualtext = '■',
            },
            buftypes = {},
        })
    end,
}
