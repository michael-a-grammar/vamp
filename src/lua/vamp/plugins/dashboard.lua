return {
  "glepnir/dashboard-nvim",

  event = "VimEnter",

  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  opts = {
    disable_move = true,
    theme = "doom",

    config = {
      header = {
        -- stylua: ignore start
'⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
'⠀⠀⠀⠀⠀⠀⢴⡾⢿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
'⠀⠀⠀⠀⣴⠗⠀⠀⠀⠹⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
'⠀⠀⠀⠈⠁⠀⠀⠀⠀⠀⢻⠻⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡆⠠⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⠀⠠⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣧⠀⢴⠄⠀⠀⠀⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡆⠠⣴⡀⠀⠀⣿⣿⣿⣿⣶⣦⣤⡀⠀⠀⠀',
'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⡄⢹⣧⠀⠀⠙⠛⠿⣿⣿⣿⠁⠀⠀⠀⠀',
'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣷⡀⢻⣧⠀⠸⠿⠀⣿⣿⣿⠀⠀⠀⠀⠀',
'┓┏        ⠀⠀⠀⠀⠹⣷⡀⢻⣇⠀⣴⣦⠈⣿⣿⠀⠀⠀⠀⠀',
'┃┃┏┓┏┳┓┏┓ ⠀⠀⠀⠀⠀⠹⣷⣠⣿⣆⢈⣁⣴⣿⣿⠀⠀⠀⠀⠀',
'┗┛┗┻┛┗┗┣┛ ⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀',
'       ┛ v0.0.1⠀⠀⠘⠿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀',
'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀',
        -- stylua: ignore end
      },

      center = {
        {
          icon = "󰯉",
          icon_hl = "markdownH1",
          desc = " Find files",
          desc_hl = "markdownH1",
          keymap = "󱁐" .. " " .. "s",
          key = "s",
          key_hl = "@character",
          key_format = " %s",
          action = "lua vim.api.nvim_input('<space>ss')",
        },

        {
          icon = "",
          icon_hl = "markdownH2",
          desc = " Recent files",
          desc_hl = "markdownH2",
          keymap = "󱁐" .. " " .. "f",
          key = "r",
          key_hl = "@character",
          key_format = " %s",
          action = "lua vim.api.nvim_input('<space>fr')",
        },

        {
          icon = "",
          icon_hl = "markdownH3",
          desc = " Terminal",
          desc_hl = "markdownH3",
          keymap = "󱁐" .. " " .. "r",
          key = "v",
          key_hl = "@character",
          key_format = " %s",
          action = "lua vim.api.nvim_input('<space>rv')",
        },

        {
          icon = "󰒲",
          icon_hl = "markdownH4",
          desc = " Lazy",
          desc_hl = "markdownH4",
          keymap = "󱁐" .. " " .. "z",
          key = "p",
          key_hl = "@character",
          key_format = " %s",
          action = "lua vim.api.nvim_command('Lazy')",
        },

        {
          icon = "󱠡",
          icon_hl = "markdownH5",
          desc = " Quit",
          desc_hl = "markdownH5",
          keymap = "󱁐" .. " " .. "q",
          key = "q",
          key_hl = "@character",
          key_format = " %s",
          action = "lua vim.api.nvim_input('<space>qq')",
        },
      },
    },
  },
}
