return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',

  opts = {
    ensure_installed = {
      'bash',
      'elixir',
      'elm',
      'eex',
      'fish',
      'lua',
      'javascript',
      'markdown',
      'markdown_inline',
      'regex',
      'ruby',
      'rust',
      'toml',
      'typescript',
      'vim',
      'vimdoc',
      'yaml',
    },

    highlight = {
      additional_vim_regex_highlighting = false,

      disable = {
        'markdown',
        'markdown_inline',
      },

      enable = true,
    },

    indent = {
      enable = true,
    },

    sync_install = false,
  },

  main = 'nvim-treesitter.configs',
}
