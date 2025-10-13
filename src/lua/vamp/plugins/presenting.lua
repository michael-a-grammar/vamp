return {
	"sotte/presenting.nvim",

	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
		"MeanderingProgrammer/render-markdown.nvim",
	},

	cmd = {
		"Presenting",
	},

	opts = {
		options = {
			width = 90,
		},

		keymaps = {
			["<cr>"] = function()
				require("presenting").next()
				vim.cmd("normal! G")
			end,

			["<bs>"] = function()
				require("presenting").prev()
				vim.cmd("normal! G")
			end,

			f = function()
				require("presenting").first()
				vim.cmd("normal! G")
			end,

			l = function()
				require("presenting").last()
				vim.cmd("normal! G")
			end,

			n = function()
				require("presenting").next()
				vim.cmd("normal! G")
			end,

			p = function()
				require("presenting").prev()
				vim.cmd("normal! G")
			end,

			q = function()
				vim.opt.cursorline = true

				vim.cmd("TSContextEnable")
				vim.cmd("RenderMarkdown disable")
				require("presenting").quit()
			end,
		},
	},

	keys = {
		{
			"<leader>zp",
			function()
				vim.opt.cursorline = false

				vim.cmd("TSContextDisable")
				vim.cmd("RenderMarkdown enable")
				vim.cmd("normal! gg")
				vim.cmd("Presenting")
				vim.cmd("normal! G")
			end,
			desc = "󰐮",
			mode = { "n", "x" },
		},
	},
}
