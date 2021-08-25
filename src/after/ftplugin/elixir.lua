local mini_ai = require('mini.ai')

vim.b.miniai_config = {
  custom_textobjects = {
    A = mini_ai.gen_spec.treesitter({
      a = '@case.outer',
      i = '@case.inner',
    }),

    G = mini_ai.gen_spec.treesitter({
      a = '@guard.outer',
      i = '@guard.inner',
    }),

    L = mini_ai.gen_spec.treesitter({
      a = '@stab_clause.outer',
      i = '@stab_clause.inner',
    }),

    O = mini_ai.gen_spec.treesitter({
      a = '@cond.outer',
      i = '@cond.inner',
    }),

    P = mini_ai.gen_spec.treesitter({
      a = '@pipe.outer',
      i = '@pipe.inner',
    }),
  },
}

vim.b.minisurround_config = {
  custom_surroundings = {
    m = {
      input = {
        vim.pesc('%{') .. '().-()' .. '}',
      },

      output = { left = '%{', right = '}' },
    },
  },
}
