local now = require("vamp.lib.safely").now

local add = vim.pack.add

now(function()
  add({
    "https://github.com/catppuccin/nvim",
    "https://github.com/rebelot/kanagawa.nvim",
  })

  if _G.vamp.catppuccin then
    require("catppuccin").setup({
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

    vim.cmd("colorscheme catppuccin")

    local catppuccin =
      require("catppuccin.palettes").get_palette(_G.vamp.catppuccin_flavour)

    vim.api.nvim_set_hl(0, "MiniJump", {
      bg = catppuccin.peach,
      fg = catppuccin.crust,
    })
  else
    require("kanagawa").setup({
      undercurl = false,
    })

    vim.cmd("colorscheme kanagawa")
  end
end)
