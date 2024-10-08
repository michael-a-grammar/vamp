return {
  'akinsho/bufferline.nvim',
  enabled = false,

  opts = {
    options = {
      diagnostics = 'nvim_lsp',
      numbers = 'both',
      separator_style = 'slant',
      show_buffer_close_icons = false,
      show_close_icon = false,

      diagnostics_indicator = function(count, level, _, context)
        if context.buffer:current() then
          return ''
        end

        local icon = level:match('error') and ''
          or level:match('hint') and '󰮥'
          or level:match('info') and ''
          or level:match('warn') and ''

        return ' ' .. icon .. ' ' .. count
      end,

      offsets = {
        {
          filetype = 'neo-tree',
          text = '󰌪',
          text_align = 'center',
        },
        {
          filetype = 'toggleterm',
          text = '',
          text_align = 'center',
        },
        {
          filetype = 'undotree',
          text = '󰕌',
          text_align = 'center',
        },
        {
          filetype = 'NeogitStatus',
          text = '',
          text_align = 'center',
        },
        {
          filetype = 'Outline',
          text = '󰊕',
          text_align = 'center',
        },
        {
          filetype = 'undotree',
          text = '',
          text_align = 'center',
        },
      },
    },
  },

  config = function(_, opts)
    opts.highlights = require('catppuccin.groups.integrations.bufferline').get()

    require('bufferline').setup(opts)
  end,
}
