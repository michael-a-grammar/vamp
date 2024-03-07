return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,

  opts = {
    background = {
      dark = 'mocha',
      light = 'latte',
    },

    flavour = 'mocha',

    integrations = {
      beacon = true,
      cmp = true,
      dashboard = true,
      gitsigns = true,
      hop = true,
      lsp_trouble = true,
      neogit = true,
      neotree = true,
      noice = true,
      notify = true,
      rainbow_delimiters = true,
      semantic_tokens = true,
      treesitter = true,
      which_key = true,

      barbecue = {
        alt_background = true,
        dim_dirname = true,
        bold_basename = true,
        dim_context = true,
      },

      mini = {
        enabled = true,
        indentscope_color = 'green',
      },

      native_lsp = {
        enabled = true,

        underlines = {
          errors = {
            'underline',
          },

          hints = {
            'underline',
          },

          information = {
            'underline',
          },

          warnings = {
            'underline',
          },
        },

        virtual_text = {
          errors = {
            'italic',
          },

          hints = {
            'italic',
          },

          information = {
            'italic',
          },

          warnings = {
            'italic',
          },
        },
      },

      navic = {
        enabled = true,
        custom_bg = 'NONE',
      },

      telescope = {
        enabled = true,
        style = 'nvchad',
      },
    },
  },

  config = function(_, opts)
    require('catppuccin').setup(opts)

    vim.api.nvim_exec('colorscheme catppuccin', false)
  end,
}
