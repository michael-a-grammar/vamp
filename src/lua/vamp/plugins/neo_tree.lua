return {
	"nvim-neo-tree/neo-tree.nvim",

	branch = "v3.x",

	dependencies = {
		"3rd/image.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"s1n7ax/nvim-window-picker",
	},

	opts = {
		close_if_last_window = true,

		commands = {
			bottom_this_line = function()
				vim.cmd("normal! zb")
			end,

			first_line = function()
				vim.cmd("normal! gg")
			end,

			middle_this_line = function()
				vim.cmd("normal! zz")
			end,

			top_this_line = function()
				vim.cmd("normal! zt")
			end,
		},

		default_component_configs = {
			diagnostics = {
				symbols = {
					error = "",
					hint = "󰮥",
					info = "",
					warn = "",
				},

				highlights = {
					error = "DiagnosticSignError",
					hint = "DiagnosticSignHint",
					info = "DiagnosticSignInfo",
					warn = "DiagnosticSignWarn",
				},
			},

			git_status = {
				symbols = {
					added = "",
					conflict = "󰶇",
					deleted = "󰛌",
					ignored = "",
					modified = "",
					renamed = "",
					staged = "",
					unstaged = "󰄱",
					untracked = "󱜸",
				},
			},

			modified = {
				symbol = "󰝤",
			},
		},

		open_files_do_not_replace_types = {
			"terminal",
			"trouble",
			"qf",
		},

		buffers = {
			window = {
				mappings = {
					["<bs>"] = "navigate_up",

					["."] = "set_root",

					["d"] = "buffer_delete",
				},
			},
		},

		filesystem = {
			follow_current_file = {
				enabled = true,
				leave_dirs_open = true,
			},

			window = {
				mappings = {
					["<bs>"] = "navigate_up",

					["."] = "set_root",
					["/"] = "filter_on_submit",

					["gn"] = "next_git_modified",
					["gp"] = "prev_git_modified",
				},

				fuzzy_finder_mappings = {
					["<c-f>"] = "move_cursor_up",
					["<c-p>"] = "move_cursor_down",
				},
			},
		},

		git_status = {
			window = {
				position = "float",
				mappings = {
					["g"] = {
						"show_help",

						config = {
							prefix_key = "g",
							title = "",
						},

						nowait = true,
					},

					["ga"] = "git_add_all",
					["gc"] = "git_commit",
					["gg"] = "git_commit_and_push",
					["gp"] = "git_push",
					["gr"] = "git_revert_file",
					["gs"] = "git_add_file",
					["gu"] = "git_unstage_file",
				},
			},
		},

		window = {
			position = "left",
			width = 30,

			mappings = {
				["="] = "toggle_auto_expand_width",

				["[g"] = "noop",
				["]g"] = "noop",

				["<cr>"] = "open",

				["h"] = "open_split",
				["i"] = "noop",
				-- ["k"] = "show_file_details",

				["p"] = {
					"toggle_preview",
					config = {
						use_float = true,
						use_image_nvim = true,
					},
				},

				["s"] = "noop",
				["v"] = "open_vsplit",
				["z"] = "noop",

				["gg"] = "first_line",

				["M"] = "close_all_nodes",
				["S"] = "noop",
			},
		},
	},

	config = function(_, opts)
		require("neo-tree").setup(opts)

		vim.keymap.set({ "n", "x" }, "<leader>l", "<cmd>Neotree reveal<cr>", { desc = "Neotree", noremap = true })

		vim.keymap.set(
			{ "n", "x" },
			"<leader>L",
			"<cmd>Neotree toggle reveal<cr>",
			{ desc = "Neotree toggle", noremap = true }
		)

		local catppuccin = require("catppuccin.palettes").get_palette(_G.catppuccin_theme)

		vim.api.nvim_set_hl(0, "NeoTreeModified", {
			fg = catppuccin.yellow,
		})

		vim.api.nvim_set_hl(0, "NeoTreeNormal", {
			bg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "NeoTreeNormalNC", {
			bg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", {
			fg = catppuccin.blue,
		})
	end,
}
