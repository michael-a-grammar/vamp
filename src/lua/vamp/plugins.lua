-- stylua: ignore start
local new_autocmd    = require('vamp.lib.new_autocmd')
local on_packchanged = require('vamp.lib.on_packchanged')
local safely         = require('vamp.lib.safely')
-- stylua: ignore end

local now, now_if_args, later, add =
  safely.now, safely.now_if_args, safely.later, vim.pack.add

now(function()
  add({
    {
      -- stylua: ignore start
      name = 'catppuccin',
      src  = 'https://github.com/catppuccin/nvim',
      -- stylua: ignore end
    },
  })

  require('catppuccin').setup({
    -- stylua: ignore start
    flavour     = _G.vamp.catppuccin_flavour,
    term_colors = true,
    transparent_background = false,
    -- stylua: ignore end

    float = {
      -- stylua: ignore start
      transparent = true,
      solid       = false,
      -- stylua: ignore end
    },

    integrations = {
      mason = true,

      mini = {
        -- stylua: ignore start
        enabled           = true,
        indentscope_color = 'surface1',
        -- stylua: ignore end
      },
    },
  })

  vim.cmd.colorscheme('catppuccin-nvim')

  local palette =
    require('catppuccin.palettes').get_palette(_G.vamp.catppuccin_flavour)

  vim.api.nvim_set_hl(0, 'MiniJump', {
    -- stylua: ignore start
    bold      = true,
    bg        = palette.base,
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

  vim.api.nvim_set_hl(0, 'MiniJump2dSpotAhead', {
    -- stylua: ignore start
    bold      = true,
    fg        = palette.teal,
    underline = true,
    -- stylua: ignore end
  })

  vim.api.nvim_set_hl(0, 'MiniJump2dSpotUnique', {
    -- stylua: ignore start
    bold      = true,
    fg        = palette.red,
    underline = true,
    -- stylua: ignore end
  })

  vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', {
    -- stylua: ignore start
    bg = palette.base,
    fg = palette.subtext0,
    -- stylua: ignore end
  })

  vim.api.nvim_set_hl(0, 'MiniStatusLineModeCommand', {
    -- stylua: ignore start
    bg = palette.base,
    fg = palette.peach,
    -- stylua: ignore end
  })

  vim.api.nvim_set_hl(0, 'MiniStatusLineModeInsert', {
    -- stylua: ignore start
    bg = palette.base,
    fg = palette.green,
    -- stylua: ignore end
  })

  vim.api.nvim_set_hl(0, 'MiniStatusLineModeNormal', {
    -- stylua: ignore start
    bg = palette.base,
    fg = palette.blue,
    -- stylua: ignore end
  })

  vim.api.nvim_set_hl(0, 'MiniStatusLineModeOther', {
    -- stylua: ignore start
    bg = palette.base,
    fg = palette.teal,
    -- stylua: ignore end
  })

  vim.api.nvim_set_hl(0, 'MiniStatusLineModeReplace', {
    -- stylua: ignore start
    bg = palette.base,
    fg = palette.red,
    -- stylua: ignore end
  })

  vim.api.nvim_set_hl(0, 'MiniStatusLineModeVisual', {
    -- stylua: ignore start
    bg = palette.base,
    fg = palette.mauve,
    -- stylua: ignore end
  })

  vim.api.nvim_set_hl(0, 'TreesitterContext', {
    bg = palette.base,
  })

  vim.api.nvim_set_hl(0, 'TreesitterContextBottom', {
    -- stylua: ignore start
    sp        = palette.lavender,
    underline = true,
    -- stylua: ignore end
  })

  vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', {
    -- stylua: ignore start
    bg        = palette.base,
    fg        = palette.lavender,
    underline = false,
    -- stylua: ignore end
  })

  vim.api.nvim_set_hl(0, 'TreesitterContextLineNumberBottom', {
    -- stylua: ignore start
    bg        = palette.base,
    fg        = palette.lavender,
    underline = false,
    -- stylua: ignore end
  })

  vim.api.nvim_set_hl(0, 'WinSeparator', {
    fg = palette.base,
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
    'typescript',
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

  local treesitter_context = require('treesitter-context')

  treesitter_context.setup({
    -- stylua: ignore start
    enable = false,
    mode   = 'topline',
    -- stylua: ignore end
  })

  vim.keymap.set(
    'n',
    '<Leader>ct',
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
        treesitter_context.go_to_context(treesitter_context_index)
      end,
      { desc = 'Go to context ' .. treesitter_context_index, noremap = true }
    )
  end
end)

now_if_args(function()
  add({ 'https://github.com/neovim/nvim-lspconfig' })

  vim.lsp.enable({
    'expert',
    'lua_ls',
    'ts_ls',
    'ts_query_ls',
  })
end)

now_if_args(function()
  add({ 'https://github.com/mason-org/mason.nvim' })

  require('mason').setup()
end)

later(function()
  add({ 'https://github.com/stevearc/conform.nvim' })

  local conform = require('conform')

  conform.setup({
    default_format_opts = {
      lsp_format = 'fallback',
    },

    formatters_by_ft = {
      lua = {
        'stylua',
      },
    },
  })

  vim.keymap.set(
    'n',
    '<Leader>n=',
    conform.format,
    { desc = 'Format', noremap = true }
  )

  vim.keymap.set(
    'x',
    '<Leader>n=',
    conform.format,
    { desc = 'Format selection', noremap = true }
  )
end)

later(function()
  add({ 'https://github.com/rafamadriz/friendly-snippets' })
end)
