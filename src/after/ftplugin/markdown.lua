-- stylua: ignore start
vim.opt_local.foldexpr   = 'v:lua.vim.treesitter.foldexpr()'
vim.opt_local.foldmethod = 'expr'
vim.opt_local.spell      = true
vim.opt_local.wrap       = true
-- stylua: ignore end

vim.keymap.del('n', 'gO', { buffer = 0 })

local pair = require('mini.ai').gen_spec.pair

vim.b.miniai_config = {
  custom_textobjects = {
    ['*'] = pair('*', '*', {
      type = 'greedy',
    }),

    ['_'] = pair('_', '_', {
      type = 'greedy',
    }),
  },
}

vim.b.minisurround_config = {
  custom_surroundings = {
    u = {
      input = {
        '%[().-()%]%(.-%)',
      },

      output = function()
        local link = require('mini.surround').user_input('Link')

        return { left = '[', right = '](' .. link .. ')' }
      end,
    },
  },
}
