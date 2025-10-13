local lazy_install_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if vim.fn.empty(vim.fn.glob(lazy_install_path)) > 0 then
	local repo = "https://github.com/folke/lazy.nvim.git"

	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		repo,
		"--branch=stable",
		lazy_install_path,
	})
end

vim.opt.rtp:prepend(lazy_install_path)

require("lazy").setup("vamp.plugins", {
	dev = {
		path = "~/vamp_local_plugins/",
	},

	ui = {
		border = "rounded",
	},
})
