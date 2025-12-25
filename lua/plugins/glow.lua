return {
    "ellisonleao/glow.nvim",
    cmd = "Glow",
    ft = { "markdown", "md", "markdown.mdx" },
    keys = {
        {
            "<leader>mg",
            "<cmd>Glow<CR>",
            desc = "Markdown: предпросмотр через glow",
            mode = "n",
        },
    },
    opts = {
        style = "dark",
        width = 120,
        height_ratio = 0.9,
        width_ratio = 0.9,
        border = "rounded",
    },
    config = function(_, opts)
        require("glow").setup(opts)
    end,
}
