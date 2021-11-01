return {
	"nvim-treesitter/nvim-treesitter",

	build = ":TSUpdate",
	main = "nvim-treesitter.configs",

	opts = {
		ensure_installed = {
			"bash",
			"elixir",
			"elm",
			"eex",
			"fennel",
			"fish",
			"lua",
			"javascript",
			"markdown",
			"markdown_inline",
			"regex",
			"ruby",
			"rust",
			"toml",
			"typescript",
			"vim",
			"vimdoc",
			"yaml",
		},

		highlight = {
			additional_vim_regex_highlighting = false,
			enable = true,
		},

		indent = {
			enable = true,
		},

		sync_install = false,
	},
}
