return {
	"s1n7ax/nvim-window-picker",

	opts = {
		filter_rules = {
			autoselect_one = true,

			bo = {
				buftype = {
					"terminal",
					"quickfix",
				},

				filetype = {
					"neo-tree",
					"neo-tree-popup",
					"notify",
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
			},

			include_current_win = false,
		},
	},
}
