vim.pack.add({
  {
  -- stylua: ignore start
  src     = 'https://github.com/nvim-mini/mini.nvim',
  version = 'main',
    -- stylua: ignore end
  },
})

_G.vamp = {}

_G.vamp.catppuccin_flavour = 'mocha'

_G.vamp.colorscheme = function(colorschemes)
  colorschemes.catppuccin()
end

require('vamp')
