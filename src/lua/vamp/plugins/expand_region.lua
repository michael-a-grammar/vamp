return {
	"terryma/vim-expand-region",

	keys = {
		{
			"<leader>pee",
			"<plug>(expand_region_expand)",
			desc = "Expand region",
			mode = { "n", "x" },
		},

		{
			"<leader>pes",
			"<plug>(expand_region_shrink)",
			desc = "Shrink region",
			mode = { "n", "x" },
		},
	},
}
