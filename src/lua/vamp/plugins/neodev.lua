return {
	"folke/neodev.nvim",

	ft = "lua",

	dependencies = {
		"neovim/nvim-lspconfig",
	},

	config = function(_, _)
		require("neodev").setup({})

		local handlers = {
			["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
			}),

			["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
			}),
		}

		require("lspconfig").lua_ls.setup({
			handlers = handlers,
		})
	end,
}
