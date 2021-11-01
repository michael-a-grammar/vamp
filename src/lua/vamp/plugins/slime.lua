return {
	"jpalardy/vim-slime",

	init = function(_)
		vim.g.slime_no_mappings = true

		if vim.env.TMUX then
			vim.g.slime_dont_ask_default = true
			vim.g.slime_target = "tmux"

			vim.g.slime_default_config = {
				socket_name = vim.split(vim.env.TMUX, ",")[1],
				target_pane = ":0.{last}",
			}
		elseif vim.env.KITTY_LISTEN_ON then
			vim.g.slime_target = "kitty"

			vim.g.slime_default_config = {
				listen_on = "unix:/tmp/mykitty",
			}
		end

		vim.keymap.set(
			{ "n", "x" },
			"<leader>c%",
			"<cmd>%SlimeSend<cr>",
			{ desc = "Send buffer to REPL", noremap = true }
		)

		vim.keymap.set(
			{ "n", "x" },
			"<leader>cc",
			"<cmd>SlimeSendCurrentLine<cr>",
			{ desc = "Send line to REPL", noremap = true }
		)

		vim.keymap.set({ "n", "x" }, "<leader>co", "<plug>(SlimeConfig)", { desc = "Configure REPL", noremap = true })

		vim.keymap.set(
			{ "n", "x" },
			"<leader>cp",
			"<plug>(SlimeParagraphSend)",
			{ desc = "Send paragraph to REPL", noremap = true }
		)

		vim.keymap.set(
			{ "n", "x" },
			"<leader>cr",
			"<plug>(SlimeRegionSend)",
			{ desc = "Send region to REPL", noremap = true }
		)

		vim.keymap.set(
			"x",
			"<leader>cs",
			"<cmd>'<,'>SlimeSend<cr>",
			{ desc = "Send selection to REPL", noremap = true }
		)
	end,
}
