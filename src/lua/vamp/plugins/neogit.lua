return {
	"NeogitOrg/neogit",

	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"sindrets/diffview.nvim",
	},

	opts = {
		disable_hint = true,
		graph_style = "unicode",
		kind = "tab",

		signs = {
			hunk = {
				"",
				"",
			},

			item = {
				"󰄾",
				"󰄼",
			},

			section = {
				"",
				"",
			},
		},

		mappings = {
			commit_editor = {
				["<c-x>"] = "Abort",
			},

			finder = {
				["<c-f>"] = "Previous",
				["<c-p>"] = "Next",
			},

			rebase_editor = {
				["<c-f>"] = "MoveUp",
				["<c-p>"] = "MoveDown",
				["<c-x>"] = "Abort",
			},

			status = {
				["<c-f>"] = "GoToPreviousHunkHeader",
				["<c-h>"] = "SplitOpen",
				["<c-p>"] = "GoToNextHunkHeader",
			},
		},
	},

	config = function(_, opts)
		local neogit = require("neogit")

		neogit.setup(opts)

		vim.keymap.set({ "n", "x" }, "<leader>ga", function()
			neogit.open({ "cherry_pick" })
		end, { desc = "Cherry Pick", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>gb", function()
			neogit.open({ "branch" })
		end, { desc = "Branch", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>gc", function()
			neogit.open({ "commit" })
		end, { desc = "Commit", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>gd", function()
			neogit.open({ "diff" })
		end, { desc = "Diff", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>ge", function()
			neogit.open({ "remote" })
		end, { desc = "Remote", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>gf", function()
			neogit.open({ "fetch" })
		end, { desc = "Fetch", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>gg", neogit.open, { desc = "Neogit dispatch", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>gh", function()
			neogit.open({ "help" })
		end, { desc = "Neogit help", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>gl", function()
			neogit.open({ "log" })
		end, { desc = "Log", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>gm", function()
			neogit.open({ "merge" })
		end, { desc = "Merge", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>gp", function()
			neogit.open({ "pull" })
		end, { desc = "Pull", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>gr", function()
			neogit.open({ "rebase" })
		end, { desc = "Rebase", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>gu", function()
			neogit.open({ "push" })
		end, { desc = "Push", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>gv", function()
			neogit.open({ "revert" })
		end, { desc = "Revert", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>gw", function()
			neogit.open({ "worktree" })
		end, { desc = "Worktree", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>gx", function()
			neogit.open({ "reset" })
		end, { desc = "Reset", noremap = true })

		vim.keymap.set({ "n", "x" }, "<leader>gz", function()
			neogit.open({ "Stash" })
		end, { desc = "Stash", noremap = true })
	end,
}
