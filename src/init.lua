vim.pack.add({
  {
    -- stylua: ignore start
    src     = 'https://github.com/nvim-mini/mini.nvim',
    version = 'main',
    -- stylua: ignore end
  },
})

_G.vamp = {}

_G.vamp.private = require('vamp.private')

_G.vamp.catppuccin_flavour = 'mocha'

require('vamp')
