return {
	"amitds1997/remote-nvim.nvim",

	config = true,
	version = "0.3.9",

	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},

	opts = {
		client_callback = function(port, _)
			local cmd = ("kitty --execute nvim --server localhost:%s --remote-ui"):format(port)

			vim.fn.jobstart(cmd, {
				detach = true,
				on_exit = function(job_id, exit_code, event_type)
					print("Client", job_id, "exited with code", exit_code, "event type:", event_type)
				end,
			})
		end,
	},
}
