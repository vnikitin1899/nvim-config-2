return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local uv = vim.uv or vim.loop

		local conditions = {
			buffer_not_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,
			hide_in_width = function()
				return vim.fn.winwidth(0) > 80
			end,
		}

		-- Кастомные компоненты для кодировки и формата конца строки
		local function file_encoding()
			local enc = vim.bo.fileencoding
			if enc == "" then
				enc = vim.bo.encoding
			end
			return enc ~= "" and enc:upper() or "UTF-8"
		end

		local function file_format()
			local format = vim.bo.fileformat
			if format == "dos" then
				return "CRLF"
			elseif format == "mac" then
				return "CR"
			else
				return "LF"
			end
		end

		local base_bg = "#1c1329"
		local git_colors = {
			base = "#edecee",
			branch = "#a277ff",
			ahead = "#82e2ff",
			behind = "#f694ff",
			added = "#61ffca",
			changed = "#ffca85",
			removed = "#ff6767",
		}

		local function now()
			if uv and uv.hrtime then
				return uv.hrtime() / 1e6
			end
			return vim.loop.hrtime() / 1e6
		end

		local git_cli_cache = {}

		local function parse_git_cli_status(lines)
			local info = { head = nil, ahead = 0, behind = 0, added = 0, changed = 0, removed = 0 }
			for _, line in ipairs(lines) do
				if line:sub(1, 2) == "##" then
					local branch = line:match("## (%S+)")
					if branch then
						local dots = branch:find("%.%.%.")
						if dots then
							branch = branch:sub(1, dots - 1)
						end
						info.head = branch
					end
					local ahead = line:match("ahead (%d+)")
					if ahead then
						info.ahead = tonumber(ahead)
					end
					local behind = line:match("behind (%d+)")
					if behind then
						info.behind = tonumber(behind)
					end
				elseif line ~= "" then
					if line:sub(1, 2) == "??" then
						info.added = info.added + 1
					else
						local x = line:sub(1, 1)
						local y = line:sub(2, 2)
						local add, change, remove = false, false, false
						for _, code in ipairs({ x, y }) do
							if code == "A" then
								add = true
							elseif code == "M" or code == "R" or code == "C" then
								change = true
							elseif code == "D" then
								remove = true
							end
						end
						if add then
							info.added = info.added + 1
						end
						if change then
							info.changed = info.changed + 1
						end
						if remove then
							info.removed = info.removed + 1
						end
					end
				end
			end
			return info
		end

		local function get_cli_git_info(dir)
			local root_result = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--show-toplevel" })
			if vim.v.shell_error ~= 0 or #root_result == 0 then
				return nil
			end
			local root = root_result[1]
			local cache = git_cli_cache[root]
			local current = now()
			if cache and (current - cache.time) < 2000 then
				return cache.data
			end
			local lines = vim.fn.systemlist({ "git", "-C", root, "status", "--porcelain", "--branch" })
			if vim.v.shell_error ~= 0 or #lines == 0 then
				return nil
			end
			local info = parse_git_cli_status(lines)
			git_cli_cache[root] = { time = current, data = info }
			return info
		end

		local function git_status()
			local buf = vim.api.nvim_get_current_buf()
			local head = vim.b.gitsigns_head
			local status = vim.b.gitsigns_status_dict

			if not head or head == "" then
				local ok, fugitive_head = pcall(vim.fn.FugitiveHead)
				if ok and fugitive_head ~= "" then
					head = fugitive_head
				else
					local buf_path = vim.api.nvim_buf_get_name(buf)
					if buf_path == "" then
						return ""
					end
					local dir = vim.fn.fnamemodify(buf_path, ":p:h")
					local git_root = vim.fs.find(".git", { path = dir, upward = true })[1]
					if git_root then
						local root = vim.fs.dirname(git_root)
						local result = vim.fn.systemlist({ "git", "-C", root, "rev-parse", "--abbrev-ref", "HEAD" })
						if vim.v.shell_error == 0 and #result > 0 then
							head = result[1]
						end
					end
				end
			end

			if not head or head == "" then
				return ""
			end

			local added = status and status.added or 0
			local changed = status and status.changed or 0
			local removed = status and status.removed or 0

			local repo_info
			local buf_path = vim.api.nvim_buf_get_name(buf)
			if buf_path ~= "" then
				local dir = vim.fn.fnamemodify(buf_path, ":p:h")
				repo_info = get_cli_git_info(dir)
			end

			if repo_info then
				head = head or repo_info.head
				added = repo_info.added or added
				changed = repo_info.changed or changed
				removed = repo_info.removed or removed
			end

			if not head or head == "" then
				return ""
			end

			local ahead = repo_info and repo_info.ahead or 0
			local behind = repo_info and repo_info.behind or 0

			local segments = { "%#LualineGitBase#" }
			local function append(hl, text)
				if not text or text == "" then
					return
				end
				local entry = string.format("%%#%s#%s", hl, text)
				table.insert(segments, entry)
				table.insert(segments, "%#LualineGitBase# ")
			end

			append("LualineGitBranch", "󰘬 " .. head)
			if ahead > 0 then
				append("LualineGitAhead", "↑" .. ahead)
			end
			if behind > 0 then
				append("LualineGitBehind", "↓" .. behind)
			end
			if added > 0 then
				append("LualineGitAdded", "+" .. added)
			end
			if changed > 0 then
				append("LualineGitChanged", "~" .. changed)
			end
			if removed > 0 then
				append("LualineGitRemoved", "-" .. removed)
			end

			if #segments == 1 then
				return ""
			end

			segments[#segments] = "%#LualineGitBase#"
			return table.concat(segments)
		end

		-- Конфигурация статус бара
		local config = {
			options = {
				globalstatus = true,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
				always_divide_middle = true,
				theme = {
					normal = {
						a = { fg = "#a277ff", bg = base_bg, gui = "bold" },
						b = { fg = "#edecee", bg = base_bg },
						c = { fg = "#edecee", bg = base_bg },
						x = { fg = "#edecee", bg = base_bg },
						y = { fg = "#edecee", bg = base_bg },
						z = { fg = "#edecee", bg = base_bg },
					},
					insert = {
						a = { fg = "#61ffca", bg = base_bg, gui = "bold" },
						b = { fg = "#edecee", bg = base_bg },
						c = { fg = "#edecee", bg = base_bg },
					},
					visual = {
						a = { fg = "#ffca85", bg = base_bg, gui = "bold" },
						b = { fg = "#edecee", bg = base_bg },
						c = { fg = "#edecee", bg = base_bg },
					},
					replace = {
						a = { fg = "#ff6767", bg = base_bg, gui = "bold" },
						b = { fg = "#edecee", bg = base_bg },
						c = { fg = "#edecee", bg = base_bg },
					},
					command = {
						a = { fg = "#82e2ff", bg = base_bg, gui = "bold" },
						b = { fg = "#edecee", bg = base_bg },
						c = { fg = "#edecee", bg = base_bg },
					},
					inactive = {
						a = { fg = "#6d6d6d", bg = base_bg },
						b = { fg = "#6d6d6d", bg = base_bg },
						c = { fg = "#6d6d6d", bg = base_bg },
						x = { fg = "#6d6d6d", bg = base_bg },
						y = { fg = "#6d6d6d", bg = base_bg },
						z = { fg = "#6d6d6d", bg = base_bg },
					},
				},
			},
			tabline = {
				lualine_a = {
					{
						"filename",
						path = 1,
						symbols = {
							modified = " ●",
							readonly = " 󰈡",
							unnamed = "󰈔",
							newfile = " 󰎔",
						},
						color = { fg = "#61ffca", bg = "NONE" },
						padding = { left = 6, right = 1 },
					},
				},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			sections = {
				-- Левая секция
				lualine_a = {
					{
						"mode",
						padding = { left = 0, right = 1 },
					},
				},
				lualine_b = {
					{
						git_status,
						padding = { left = 1, right = 1 },
					},
					{
						"diff",
						symbols = { added = "󰐕 ", modified = "󰏫 ", removed = "󰍴 " },
						condition = conditions.hide_in_width,
						padding = { left = 1, right = 1 },
					},
				},
				lualine_c = {},
				-- Правая секция
				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = "󰅚 ", warn = "󰀪 ", info = "󰋽 ", hint = "󰌶 " },
						padding = { left = 1, right = 1 },
					},
					{
						"filetype",
						icon_only = false,
						padding = { left = 1, right = 1 },
					},
					{
						file_encoding,
						padding = { left = 1, right = 1 },
						condition = conditions.hide_in_width,
					},
					{
						file_format,
						padding = { left = 1, right = 1 },
						condition = conditions.hide_in_width,
					},
				},
				lualine_y = {
					{
						"location",
						padding = { left = 1, right = 1 },
					},
				},
				lualine_z = {},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			extensions = {},
		}

		lualine.setup(config)

		local function apply_status_colors()
			vim.api.nvim_set_hl(0, "StatusLine", { fg = "#edecee", bg = base_bg })
			vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#6d6d6d", bg = base_bg })
			vim.api.nvim_set_hl(0, "TabLineFill", { bg = base_bg })
			vim.api.nvim_set_hl(0, "TabLine", { fg = "#61ffca", bg = base_bg })
			vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#61ffca", bg = base_bg, bold = true })
			vim.api.nvim_set_hl(0, "LualineGitBase", { fg = git_colors.base, bg = base_bg })
			vim.api.nvim_set_hl(0, "LualineGitBranch", { fg = git_colors.branch, bg = base_bg, bold = true })
			vim.api.nvim_set_hl(0, "LualineGitAhead", { fg = git_colors.ahead, bg = base_bg })
			vim.api.nvim_set_hl(0, "LualineGitBehind", { fg = git_colors.behind, bg = base_bg })
			vim.api.nvim_set_hl(0, "LualineGitAdded", { fg = git_colors.added, bg = base_bg })
			vim.api.nvim_set_hl(0, "LualineGitChanged", { fg = git_colors.changed, bg = base_bg })
			vim.api.nvim_set_hl(0, "LualineGitRemoved", { fg = git_colors.removed, bg = base_bg })
		end

		apply_status_colors()

		vim.api.nvim_create_autocmd({ "ColorScheme", "BufEnter", "WinEnter" }, {
			callback = apply_status_colors,
		})
	end,
}
