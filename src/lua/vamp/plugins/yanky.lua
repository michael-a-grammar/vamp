return {
	"gbprod/yanky.nvim",

	keys = {
		{
			"<leader>pyg",
			"<plug>(YankyGPutAfter)",
			desc = "Yank ring put and leave after cursor",
			mode = { "n", "x" },
		},

		{
			"<leader>pyG",
			"<plug>(YankyGPutBefore)",
			desc = "Yank ring put and leave before cursor",
			mode = { "n", "x" },
		},

		{
			"<leader>pyn",
			"<plug>(YankyNextEntry)",
			desc = "Yank ring next entry",
			mode = { "n", "x" },
		},

		{
			"<leader>pyp",
			"<plug>(YankyPreviousEntry)",
			desc = "Yank ring previous entry",
			mode = { "n", "x" },
		},

		{
			"<leader>pyu",
			"<plug>(YankyPutAfter)",
			desc = "Yank ring put after cursor",
			mode = { "n", "x" },
		},

		{
			"<leader>pyU",
			"<plug>(YankyPutBefore)",
			desc = "Yank ring put before cursor",
			mode = { "n", "x" },
		},
	},

	opts = {
		ring = {
			storage = "memory",
		},
	},
}
