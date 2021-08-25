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
  })

  local function catppuccin()
    vim.cmd('colorscheme catppuccin')

    local palette =
      require('catppuccin.palettes').get_palette(_G.vamp.catppuccin_flavour)

    vim.api.nvim_set_hl(0, 'MiniJump', {
      -- stylua: ignore start
      bold      = true,
      fg        = palette.peach,
      underline = true,
      -- stylua: ignore end
    })

    vim.api.nvim_set_hl(0, 'MiniJump2dSpot', {
      -- stylua: ignore start
      bold      = true,
      fg        = palette.peach,
      underline = true,
      -- stylua: ignore end
    })

    vim.api.nvim_set_hl(0, 'MiniJump2dSpotUnique', {
      -- stylua: ignore start
      bold      = true,
      fg        = palette.peach,
      underline = true,
      -- stylua: ignore end
    })

    vim.api.nvim_set_hl(0, 'MiniJump2dSpotAhead', {
      -- stylua: ignore start
      bold      = true,
      fg        = palette.teal,
      underline = true,
      -- stylua: ignore end
    })

    vim.api.nvim_set_hl(0, 'TreesitterContext', {
      bg = palette.base,
    })

    vim.api.nvim_set_hl(0, 'TreesitterContextBottom', {
      -- stylua: ignore start
      sp        = palette.blue,
      underline = true,
      -- stylua: ignore end
    })

    vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', {
      -- stylua: ignore start
      bg        = palette.base,
      fg        = palette.blue,
      underline = false,
      -- stylua: ignore end
    })

    vim.api.nvim_set_hl(0, 'TreesitterContextLineNumberBottom', {
      -- stylua: ignore start
      bg        = palette.base,
      fg        = palette.blue,
      underline = false,
      -- stylua: ignore end
    })
  end

  require('catppuccin').setup({
    -- stylua: ignore start
    flavour     = _G.vamp.catppuccin_flavour,
    term_colors = true,
    -- stylua: ignore end

    integrations = {
      mini = {
        enabled = true,
      },
    },
  })

  _G.vamp.colorscheme({
    -- stylua: ignore start
    catppuccin = catppuccin,
    solarized  = solarized,
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
  add({
    'https://github.com/nvim-treesitter/nvim-treesitter-context',
  })

  vim.keymap.set(
    'n',
    '<Leader>ke',
    '<Cmd>TSContext toggle<CR>',
    { desc = 'Toggle Treesitter Context', noremap = true }
  )

  for index = 1, 9, 1 do
    -- stylua: ignore start
    local treesitter_context_index = tostring(index)
    local keymap_index             = index == 1 and 'c' or treesitter_context_index
    -- stylua: ignore end

    vim.keymap.set(
      { 'n', 'x' },
      '<Leader>c' .. keymap_index,
      function()
        require('treesitter-context').go_to_context(treesitter_context_index)
      end,
      { desc = 'Go to context ' .. treesitter_context_index, noremap = true }
    )
  end

  local palette =
    require('catppuccin.palettes').get_palette(_G.vamp.catppuccin_flavour)
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
