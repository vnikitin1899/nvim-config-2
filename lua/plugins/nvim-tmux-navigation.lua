return {
	"alexghergh/nvim-tmux-navigation",
	event = "VeryLazy",
	config = function()
		local navigation = require("nvim-tmux-navigation")
		navigation.setup({
			disable_when_zoomed = true,
			keybindings = {
				left = "<C-h>",
				down = "<C-j>",
				up = "<C-k>",
				right = "<C-l>",
				last_active = "<C-\\>",
				next = "<C-Space>",
			},
		})
	end,
}
