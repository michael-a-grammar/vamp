return {
  "nvim-tree/nvim-web-devicons",

  lazy = true,

  config = function(_, opts)
    local web_devicons = require("nvim-web-devicons")

    local catppuccin =
      require("catppuccin.palettes").get_palette(_G.catppuccin_theme)

    local icons = web_devicons.get_icons()

    local colors = {
      catppuccin.sapphire,
      catppuccin.teal,
      catppuccin.blue,
      catppuccin.green,
      catppuccin.mauve,
      catppuccin.peach,
      catppuccin.red,
      catppuccin.lavender,
      catppuccin.yellow,
    }

    local colors_length = 0

    for index, _ in ipairs(colors) do
      colors_length = index
    end

    local colors_index = 1

    for _, icon in pairs(icons) do
      if colors_index >= colors_length then
        colors_index = 1
      end

      icon.color = colors[colors_index]
      colors_index = colors_index + 1
    end

    opts.override_by_filename = icons

    web_devicons.setup(opts)
  end,
}
