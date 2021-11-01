return {
	"MeanderingProgrammer/render-markdown.nvim",

	dependencies = {
		"catppuccin/nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},

	keys = {
		{
			"<leader>km",
			"<cmd>RenderMarkdown toggle<cr>",
			desc = "Toggle Render Markdown",
			mode = { "n", "x" },
		},
	},

	opts = {
		heading = {
			border = true,
			icons = { " ", " ", " ", " ", " ", " " },
			left_pad = 0.5,
		},

		link = {
			image = "",
		},
	},

	config = function(_, opts)
		require("render-markdown").setup(opts)

		local catppuccin = require("catppuccin.palettes").get_palette(_G.catppuccin_theme)

		vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", {
			bg = catppuccin.lavender,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "RenderMarkdownH1", {
			bg = catppuccin.lavender,
			fg = catppuccin.base,
		})
	end,
}
