return {
	"catppuccin/nvim",

	name = "catppuccin",
	priority = 1000,

	opts = {
		background = {
			dark = _G.catppuccin_theme,
			light = "latte",
		},

		flavour = _G.catppuccin_theme,

		integrations = {
			beacon = true,
			cmp = true,
			dashboard = true,
			diffview = true,
			flash = true,
			gitsigns = true,
			grug_far = true,
			harpoon = true,
			headlines = true,
			lsp_trouble = true,
			markdown = true,
			neogit = true,
			neotree = true,
			noice = true,
			notify = true,
			rainbow_delimiters = true,
			sandwich = true,
			semantic_tokens = true,
			symbols_outline = true,
			treesitter = true,
			treesitter_context = true,
			which_key = true,
			window_picker = true,

			barbecue = {
				alt_background = true,
				dim_dirname = true,
				bold_basename = true,
				dim_context = true,
			},

			illuminate = {
				enabled = true,
				lsp = false,
			},

			mini = {
				enabled = true,
				indentscope_color = "lavender",
			},

			native_lsp = {
				enabled = true,

				underlines = {
					errors = {
						"underline",
					},

					hints = {
						"underline",
					},

					information = {
						"underline",
					},

					warnings = {
						"underline",
					},
				},

				virtual_text = {
					errors = {
						"italic",
					},

					hints = {
						"italic",
					},

					information = {
						"italic",
					},

					warnings = {
						"italic",
					},
				},
			},

			navic = {
				enabled = true,
				custom_bg = "NONE",
			},

			telescope = {
				enabled = true,
			},
		},
	},

	config = function(_, opts)
		require("catppuccin").setup(opts)

		vim.api.nvim_exec2("colorscheme catppuccin", {})

		local catppuccin = require("catppuccin.palettes").get_palette(_G.catppuccin_theme)

		vim.api.nvim_set_hl(0, "NormalFloat", {
			bg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "Pmenu", {
			bg = catppuccin.base,
			fg = catppuccin.text,
		})

		vim.api.nvim_set_hl(0, "PmenuSel", {
			bg = catppuccin.base,
			fg = catppuccin.text,
		})

		vim.api.nvim_set_hl(0, "WinSeparator", {
			fg = catppuccin.blue,
		})

		vim.g.terminal_color_0 = catppuccin.surface1
		vim.g.terminal_color_1 = catppuccin.red
		vim.g.terminal_color_2 = catppuccin.green
		vim.g.terminal_color_3 = catppuccin.yellow
		vim.g.terminal_color_4 = catppuccin.blue
		vim.g.terminal_color_5 = catppuccin.pink
		vim.g.terminal_color_6 = catppuccin.teal
		vim.g.terminal_color_7 = catppuccin.subtext1
		vim.g.terminal_color_8 = catppuccin.surface2
		vim.g.terminal_color_9 = catppuccin.red
		vim.g.terminal_color_10 = catppuccin.green
		vim.g.terminal_color_11 = catppuccin.yellow
		vim.g.terminal_color_12 = catppuccin.blue
		vim.g.terminal_color_13 = catppuccin.pink
		vim.g.terminal_color_14 = catppuccin.teal
		vim.g.terminal_color_15 = catppuccin.subtext0
	end,
}
