return {
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		opts = {
			stages = "slide",
			render = "compact",
			timeout = 3000,
			level = vim.log.levels.INFO,
			top_down = false,
			background_colour = "#15141b",
		},
		config = function(_, opts)
			local notify = require("notify")
			notify.setup(opts)
			vim.notify = notify
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = function()
			local float_border = {
				style = "rounded",
				padding = { 0, 1 },
			}

			local function calc_center_layout()
				local columns = vim.o.columns
				local lines = vim.o.lines

				local width = math.floor(columns * 0.55)
				width = math.max(40, math.min(width, 80))
				width = math.min(width, columns - 4)

				local col = math.max(0, math.floor((columns - width) / 2))
				local row = math.max(1, math.floor(lines / 2) - 2)

				return width, col, row
			end

			local cmd_width, cmd_col, cmd_row = calc_center_layout()
			local popup_row = math.min(cmd_row + 3, vim.o.lines - 3)

			return {
				cmdline = {
					enabled = true,
					view = "cmdline_popup",
				},
				messages = {
					enabled = true,
					view = "notify",
					view_error = "notify",
					view_warn = "notify",
					view_history = "split",
					view_search = false,
				},
				popupmenu = {
					enabled = true,
					backend = "nui",
					kind_icons = {},
				},
				notify = {
					enabled = true,
					view = "notify",
				},
				lsp = {
					progress = {
						enabled = true,
						view = "mini",
					},
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				views = {
					cmdline_popup = {
						position = {
							row = cmd_row,
							col = cmd_col,
						},
						relative = "editor",
						size = {
							width = cmd_width,
							height = "auto",
							max_width = 80,
						},
						border = float_border,
						win_options = {
							winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
						},
					},
					popupmenu = {
						relative = "editor",
						position = {
							row = popup_row,
							col = cmd_col,
						},
						size = {
							width = cmd_width,
							height = 10,
						},
						border = float_border,
						win_options = {
							winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
						},
					},
					mini = {
						timeout = 2000,
						win_options = {
							winblend = 10,
						},
					},
				},
				routes = {
					{
						filter = {
							event = "msg_show",
							find = "written",
						},
						opts = { skip = true },
					},
					{
						filter = {
							event = "notify",
							find = "No information available",
						},
						opts = { skip = true },
					},
				},
				presets = {
					bottom_search = true,
					command_palette = false,
					long_message_to_split = true,
					inc_rename = true,
					lsp_doc_border = true,
				},
			}
		end,
		config = function(_, opts)
			require("noice").setup(opts)
		end,
	},
}
