return {
	"ThePrimeagen/harpoon",

	dependencies = {
		"nvim-telescope/telescope.nvim",
	},

	keys = {
		{
			"<leader>hh",
			"<cmd>Telescope harpoon marks theme=ivy<cr>",
			desc = "Harpoon",
			mode = { "n", "x" },
		},

		{
			"<leader>hn",
			function()
				require("harpoon.ui").nav_next()
			end,
			desc = "Next harpoon",
			mode = { "n", "x" },
		},

		{
			"<leader>hn",
			function()
				require("harpoon.ui").nav_prev()
			end,
			desc = "Previous harpoon",
			mode = { "n", "x" },
		},

		{
			"<leader>ht",
			function()
				require("harpoon.ui").toggle_quick_menu()
			end,
			desc = "Harpoon quick menu",
			mode = { "n", "x" },
		},

		{
			"<leader>nh",
			function()
				require("harpoon.mark").add_file()
			end,
			desc = "Harpoon here",
			mode = { "n", "x" },
		},
	},

	config = function(_, _)
		require("telescope").load_extension("harpoon")
	end,
}
