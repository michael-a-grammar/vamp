-- stylua: ignore start
local new_autocmd    = require('vamp.lib.new_autocmd')
local on_packchanged = require('vamp.lib.on_packchanged')
local safely         = require('vamp.lib.safely')
-- stylua: ignore end

local now, now_if_args, later, add =
  safely.now, safely.now_if_args, safely.later, vim.pack.add

now(function()
  add({
    'https://github.com/catppuccin/nvim',
    'https://github.com/rebelot/kanagawa.nvim',
  })

  local catppuccin = function()
    require('catppuccin').setup({
      background = {
      -- stylua: ignore start
      dark  = "mocha",
      light = "latte",
        -- stylua: ignore end
      },

    -- stylua: ignore start
    flavour     = "mocha",
    term_colors = true,
      -- stylua: ignore end

      integrations = {
        mini = {
          enabled = true,
        },
      },
    })

    vim.cmd('colorscheme catppuccin')

    local catppuccin =
      require('catppuccin.palettes').get_palette(_G.vamp.catppuccin_flavour)

    vim.api.nvim_set_hl(0, 'MiniJump', {
      bg = catppuccin.peach,
      fg = catppuccin.crust,
    })
  end

  local kanagawa = function()
    require('kanagawa').setup({
      undercurl = false,
    })

    vim.cmd('colorscheme kanagawa')
  end

  _G.vamp.colorscheme({
    -- stylua: ignore start
    catppuccin = catppuccin,
    kanagawa   = kanagawa,
    -- stylua: ignore end
  })
end)

now_if_args(function()
  add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  })

  local languages = {
    'lua',
    'vimdoc',
    'markdown',
    'elixir',
  }

  require('nvim-treesitter').install(languages)

  local filetypes = {}

  for _, language in ipairs(languages) do
    for _, filetype in ipairs(vim.treesitter.language.get_filetypes(language)) do
      table.insert(filetypes, filetype)
    end
  end

  new_autocmd('FileType', filetypes, function(event)
    vim.treesitter.start(event.buf)
  end, 'Start treesitter')

  on_packchanged('nvim-treesitter', { 'update' }, function()
    vim.cmd('TSUpdate')
  end, 'Update treesitter parsers')
end)

now_if_args(function()
  add({ 'https://github.com/neovim/nvim-lspconfig' })
end)

later(function()
  add({ 'https://github.com/stevearc/conform.nvim' })

  require('conform').setup({
    default_format_opts = {
      lsp_format = 'fallback',
    },

    formatters_by_ft = {
      lua = {
        'stylua',
      },
    },
  })
end)

later(function()
  add({ 'https://github.com/rafamadriz/friendly-snippets' })
end)
