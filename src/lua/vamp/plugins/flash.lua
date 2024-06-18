return {
  'folke/flash.nvim',
  event = 'VeryLazy',

  opts = {
    labels = 'ntesiroamghdkvclpufxzufq',

    prompt = {
      prefix = {
        {
          '󱐌',
          'FlashPromptIcon',
        },
      },
    },
  },

  keys = {
    {
      '<bs>r',
      mode = 'o',
      function()
        require('flash').remote()
      end,
      desc = 'Remote flash',
    },

    {
      '<bs>s',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash',
    },

    {
      '<bs>t',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').treesitter()
      end,
      desc = 'Flash treesitter',
    },
  },
}
