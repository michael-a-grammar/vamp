return {
	"nvim-lualine/lualine.nvim",

	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	opts = function(_, _)
		local catppuccin = require("catppuccin.palettes").get_palette(_G.catppuccin_theme)

		local colors = {
			bg = catppuccin.crust,
			blue = catppuccin.sapphire,
			cyan = catppuccin.teal,
			dark_fg = catppuccin.surface2,
			darkblue = catppuccin.blue,
			fg = catppuccin.text,
			green = catppuccin.green,
			magenta = catppuccin.mauve,
			orange = catppuccin.peach,
			red = catppuccin.red,
			violet = catppuccin.lavender,
			yellow = catppuccin.yellow,
		}

		local conditions = {
			is_buffer_empty = function()
				return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
			end,

			hide = function()
				return vim.fn.winwidth(0) > 80
			end,
		}

		local opts = {
			options = {
				component_separators = "",
				section_separators = "",

				disabled_filetypes = {
					"lazy",
					"neo-tree",
					"neo-tree-popup",
					"notify",
					"qf",
					"trouble",
					"toggleterm",
					"undotree",
					"DiffviewFiles",
					"DiffviewFileHistory",
					"NeogitCommandHistory",
					"NeogitCommitView",
					"NeogitPopup",
					"NeogitStatus",
					"Outline",
					"TelescopePrompt",
				},

				theme = {
					normal = {
						c = {
							fg = colors.fg,
							bg = colors.bg,
						},
					},

					inactive = {
						c = {
							fg = colors.fg,
							bg = colors.bg,
						},
					},
				},
			},

			sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},

			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_y = {},
				lualine_z = {},
				lualine_c = {},
				lualine_x = {},
			},
		}

		local function insert_into_left_section(component)
			table.insert(opts.sections.lualine_c, component)
		end

		local function insert_into_right_section(component)
			table.insert(opts.sections.lualine_x, component)
		end

		insert_into_left_section({
			function()
				return "▊"
			end,

			color = {
				fg = colors.blue,
			},

			padding = {
				left = 0,
				right = 1,
			},
		})

		insert_into_left_section({
			function()
				return "󰣐"
			end,

			color = function()
				local mode_color = {
					n = colors.red,
					i = colors.green,
					v = colors.blue,
					[""] = colors.blue,
					V = colors.blue,
					c = colors.magenta,
					no = colors.red,
					s = colors.orange,
					S = colors.orange,
					ic = colors.yellow,
					R = colors.violet,
					Rv = colors.violet,
					cv = colors.red,
					ce = colors.red,
					r = colors.cyan,
					rm = colors.cyan,
					["r?"] = colors.cyan,
					["!"] = colors.red,
					t = colors.red,
				}

				return {
					fg = mode_color[vim.fn.mode()],
				}
			end,

			padding = {
				right = 1,
			},
		})

		insert_into_left_section({
			"filename",

			color = {
				fg = colors.magenta,
				gui = "bold",
			},

			cond = conditions.is_buffer_empty,
		})

		insert_into_left_section({
			"filetype",

			color = {
				fg = colors.magenta,
				gui = "bold",
			},

			cond = conditions.is_buffer_empty,

			icon_only = true,
		})

		insert_into_left_section({
			"filesize",

			color = {
				fg = colors.dark_fg,
				gui = "bold",
			},

			cond = conditions.is_buffer_empty,
		})

		insert_into_left_section({
			"location",

			color = {
				fg = colors.dark_fg,
			},
		})

		insert_into_left_section({
			"progress",

			color = {
				fg = colors.dark_fg,
			},
		})

		insert_into_left_section({
			"diagnostics",

			sources = { "nvim_diagnostic" },

			symbols = {
				error = "" .. " ",
				hint = "󰮥" .. " ",
				info = "" .. " ",
				warn = "" .. " ",
			},

			diagnostics_color = {
				color_error = {
					fg = colors.red,
				},

				color_hint = {
					fg = colors.cyan,
				},

				color_info = {
					fg = colors.cyan,
				},

				color_warn = {
					fg = colors.yellow,
				},
			},
		})

		insert_into_left_section({
			function()
				return "%="
			end,
		})

		insert_into_left_section({
			function()
				local no_lsp_message = "󰝾"
				local lsp_message = "" .. "  "
				local clients = vim.lsp.get_clients()

				if next(clients) == nil then
					return no_lsp_message
				end

				for index, client in ipairs(clients) do
					if index > 1 then
						lsp_message = lsp_message .. ", "
					end

					lsp_message = lsp_message .. client.name or client.config.name
				end

				return lsp_message
			end,

			color = {
				fg = colors.dark_fg,
				gui = "bold",
			},
		})

		insert_into_right_section({
			function()
				return require("noice").api.status.mode:get():gsub("^recording @(.-)$", "󰑋 %1")
			end,

			color = {
				fg = colors.magenta,
			},

			cond = require("noice").api.status.mode.has,
		})

		insert_into_right_section({
			function()
				return require("noice").api.status.command
					.get()
					:gsub("~@k$", " ")
					:gsub("<20>", " 󱁐 ")
					:gsub("%^%[", " 󱊷 ")
					:gsub("%^", " 󰘴 ")
					:gsub('"(.)p', "   󰳴 %1")
					:gsub('"(.)', " 󰳴 %1")
					:gsub("^%s*(.-)%s*$", "%1")
			end,

			color = {
				fg = colors.orange,
			},

			cond = require("noice").api.status.command.has,
		})

		insert_into_right_section({
			"o:encoding",

			color = {
				fg = colors.green,
				gui = "bold",
			},

			cond = conditions.hide,
		})

		insert_into_right_section({
			"fileformat",

			color = {
				fg = colors.green,
				gui = "bold",
			},

			icons_enabled = false,
		})

		insert_into_right_section({
			"branch",

			color = {
				fg = colors.violet,
				gui = "bold",
			},

			fmt = function(section)
				if string.len(section) > 1 then
					local split = vim.split(section, "/")

					if table.maxn(split) > 1 then
						return split[1]
					end
				end

				return section
			end,

			icon = "",
		})

		insert_into_right_section({
			"diff",

			cond = conditions.hide,

			diff_color = {
				added = {
					fg = colors.green,
				},

				modified = {
					fg = colors.yellow,
				},

				removed = {
					fg = colors.red,
				},
			},

			symbols = {
				added = "" .. " ",
				modified = "󰝤" .. " ",
				removed = "" .. " ",
			},
		})

		return opts
	end,
}
