return {
	"folke/noice.nvim",

	event = "VeryLazy",

	dependencies = {
		"MunifTanjim/nui.nvim",

		{
			"rcarriga/nvim-notify",

			opts = {
				render = "default",
				stages = "fade",
			},
		},
	},

	opts = {
		lsp = {
			override = {
				["cmp.entry.get_documentation"] = true,
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = false,
			},
		},

		presets = {
			bottom_search = false,
			command_palette = true,
			inc_rename = true,
			long_message_to_split = true,
			lsp_doc_border = true,
		},

		views = {
			cmdline_popup = {
				position = {
					col = "50%",
					row = 10,
				},

				size = {
					height = "auto",
					width = 60,
				},
			},

			popupmenu = {
				border = {
					padding = { 0, 1 },
					style = "rounded",
				},

				position = {
					col = "50%",
					row = 13,
				},

				relative = "editor",

				size = {
					height = 10,
					width = 60,
				},
			},
		},
	},

	config = function(_, opts)
		local noice = require("noice")

		noice.setup(opts)

		require("telescope").load_extension("noice")

		vim.keymap.set({ "n", "x" }, "<leader>aa", function()
			noice.cmd("dismiss")
		end, { desc = "Dimiss notifications", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>ae", function()
			noice.cmd("errors")
		end, { desc = "Error notifications", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>ah", function()
			vim.cmd("Telescope noice")
		end, { desc = "Notifications history", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>al", function()
			noice.cmd("last")
		end, { desc = "Last notification", noremap = true })

		vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
			if not require("noice.lsp").scroll(-4) then
				return "<c-f>"
			end
		end, { desc = "LSP hover doc scroll up", expr = true, silent = true })

		vim.keymap.set({ "n", "i", "s" }, "<c-p>", function()
			if not require("noice.lsp").scroll(4) then
				return "<c-p>"
			end
		end, {
			desc = "LSP hover doc scroll down",
			expr = true,
			silent = true,
		})

		local catppuccin = require("catppuccin.palettes").get_palette(_G.catppuccin_theme)

		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", {
			fg = catppuccin.blue,
		})

		vim.api.nvim_set_hl(0, "NoicePopupmenu", {
			fg = catppuccin.overlay0,
		})

		vim.api.nvim_set_hl(0, "NoicePopupmenuMatch", {
			fg = catppuccin.green,
			bold = true,
		})

		vim.api.nvim_set_hl(0, "NoicePopupmenuSelected", {
			link = "CursorLine",
		})
	end,
}
