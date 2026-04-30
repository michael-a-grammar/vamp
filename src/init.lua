vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

_G.vamp = {}

_G.vamp.catppuccin_flavour = 'mocha'

_G.vamp.colorscheme = function(colorschemes)
  colorschemes.catppuccin()
end

require('vamp')
