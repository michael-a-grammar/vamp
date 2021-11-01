local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set({ "n", "x" }, "<leader>ma", function()
	vim.cmd.RustLsp("codeAction")
end, {
	desc = "Code actions",
	buffer = bufnr,
	silent = true,
	noremap = true,
})

vim.keymap.set({ "n", "x" }, "<leader>mdd", function()
	vim.cmd.RustLsp("renderDiagnostic")
end, {
	desc = "Render diagnostic",
	buffer = bufnr,
	silent = true,
	noremap = true,
})

vim.keymap.set({ "n", "x" }, "<leader>mde", function()
	vim.cmd.RustLsp("explainError")
end, {
	desc = "Explain error",
	buffer = bufnr,
	silent = true,
	noremap = true,
})

vim.keymap.set("n", "<leader>mh", function()
	vim.cmd.RustLsp({ "hover", "actions" })
end, {
	desc = "Hover actions",
	buffer = bufnr,
	silent = true,
	noremap = true,
})

vim.keymap.set("x", "<leader>mh", function()
	vim.cmd.RustLsp({ "hover", "range" })
end, {
	desc = "Hover range",
	buffer = bufnr,
	silent = true,
	noremap = true,
})

vim.keymap.set({ "n", "x" }, "<leader>mif", function()
	vim.cmd.RustLsp({ "moveItem", "up" })
end, {
	desc = "Move item up",
	buffer = bufnr,
	silent = true,
	noremap = true,
})

vim.keymap.set({ "n", "x" }, "<leader>mii", function()
	vim.cmd.RustLsp("joinLines")
end, {
	desc = "Join lines",
	buffer = bufnr,
	silent = true,
	noremap = true,
})

vim.keymap.set({ "n", "x" }, "<leader>mip", function()
	vim.cmd.RustLsp({ "moveItem", "down" })
end, {
	desc = "Move item down",
	buffer = bufnr,
	silent = true,
	noremap = true,
})

vim.keymap.set({ "n", "x" }, "<leader>mmm", function()
	vim.cmd.RustLsp("expandMacro")
end, {
	desc = "Expand macro",
	buffer = bufnr,
	silent = true,
	noremap = true,
})

vim.keymap.set({ "n", "x" }, "<leader>mmp", function()
	vim.cmd.RustLsp("rebuildProMacros")
end, {
	desc = "Rebuild pro macros",
	buffer = bufnr,
	silent = true,
	noremap = true,
})

vim.keymap.set({ "n", "x" }, "<leader>mp", function()
	vim.cmd.RustLsp({ "runnables", bang = true })
end, {
	desc = "Rerun previous runnable",
	buffer = bufnr,
	silent = true,
	noremap = true,
})

vim.keymap.set({ "n", "x" }, "<leader>mr", function()
	vim.cmd.RustLsp("runnables")
end, {
	desc = "Runnables",
	buffer = bufnr,
	silent = true,
	noremap = true,
})

vim.keymap.set({ "n", "x" }, "<leader>msc", function()
	vim.cmd.RustLsp("openCargo")
end, {
	desc = "Open cargo",
	buffer = bufnr,
	silent = true,
	noremap = true,
})

vim.keymap.set({ "n", "x" }, "<leader>msp", function()
	vim.cmd.RustLsp("parentModule")
end, {
	desc = "Parent module",
	buffer = bufnr,
	silent = true,
	noremap = true,
})

vim.keymap.set({ "n", "x" }, "<leader>mss", function()
	vim.cmd.RustLsp("workspaceSymbol")
end, {
	desc = "Workspace symbol search",
	buffer = bufnr,
	silent = true,
	noremap = true,
})

vim.keymap.set({ "n", "x" }, "<leader>mss", function()
	vim.cmd.RustLsp({ "workspaceSymbol", "onlyTypes" })
end, {
	desc = "Workspace type symbol search",
	buffer = bufnr,
	silent = true,
	noremap = true,
})

vim.keymap.set({ "n", "x" }, "<leader>mtp", function()
	vim.cmd.RustLsp({ "testables", bang = true })
end, {
	desc = "Rerun previous testable",
	buffer = bufnr,
	silent = true,
	noremap = true,
})

vim.keymap.set({ "n", "x" }, "<leader>mtt", function()
	vim.cmd.RustLsp("testables")
end, {
	desc = "Testables",
	buffer = bufnr,
	silent = true,
	noremap = true,
})

local to_add = {
	{
		["<leader>"] = {
			mode = {
				"n",
				"x",
			},

			{
				"<leader>m",
				group = "",
			},

			{
				"<leader>md",
				group = "Diagnostics",
			},

			{
				"<leader>mi",
				group = "Move item",
			},

			{
				"<leader>mm",
				group = "Macros",
			},

			{
				"<leader>mr",
				group = "Runnables",
			},

			{
				"<leader>ms",
				group = "Find",
			},

			{
				"<leader>mt",
				group = "Testables",
			},
		},
	},
}

local which_key = require("which-key")

which_key.add(to_add)
