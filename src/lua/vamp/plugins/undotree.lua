return {
	"jiaoshijie/undotree",

	config = true,

	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	keys = {
		{
			"<leader>nu",
			function()
				require("undotree").toggle()
			end,
			desc = "Undo tree",
			mode = { "n", "x" },
		},
	},
}
