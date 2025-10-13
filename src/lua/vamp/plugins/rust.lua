return {
	"mrcjkb/rustaceanvim",

	ft = "rust",
	version = "^4",

	config = function(_, _)
		local handlers = {
			["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = "rounded",
			}),
		}

		vim.g.rustaceanvim = {
			server = {
				handlers = handlers,
			},

			tools = {
				test_executor = "background",
			},
		}
	end,
}
