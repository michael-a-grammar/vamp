return {
  "nvim-treesitter/nvim-treesitter",

  build = ":TSUpdate",
  lazy = false,

  opts = {
    ensure_installed = {
      "bash",
      "elixir",
      "eex",
      "fish",
      "lua",
      "javascript",
      "markdown",
      "markdown_inline",
      "regex",
      "toml",
      "typescript",
      "yaml",
    },

    highlight = {
      additional_vim_regex_highlighting = false,
      enable = true,
    },

    indent = {
      enable = true,
    },

    sync_install = false,
  },
}
