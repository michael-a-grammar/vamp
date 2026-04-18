return {
  "catppuccin/nvim",

  name = "catppuccin",
  priority = 1000,

  opts = {
    background = {
      dark = _G.catppuccin_theme,
      light = "latte",
    },

    flavour = _G.catppuccin_theme,

    term_colors = true,

    float = {
      solid = true,
    },

    integrations = {
      cmp = true,
      dashboard = true,
      diffview = true,
      flash = true,
      gitsigns = true,
      grug_far = true,
      lsp_trouble = true,
      neogit = true,
      neotree = true,
      noice = true,
      notify = true,
      treesitter_context = true,
      which_key = true,

      barbecue = {
        alt_background = true,
        dim_dirname = true,
        bold_basename = true,
        dim_context = true,
      },

      mini = {
        enabled = true,
      },

      navic = {
        enabled = true,
        custom_bg = "NONE",
      },

      telescope = {
        enabled = true,
      },
    },
  },

  config = function(_, opts)
    require("catppuccin").setup(opts)

    vim.api.nvim_exec2("colorscheme catppuccin", {})

    local catppuccin =
      require("catppuccin.palettes").get_palette(_G.catppuccin_theme)

    -- vim.api.nvim_set_hl(0, "NormalFloat", {
    -- 	bg = catppuccin.base,
    -- })

    -- vim.api.nvim_set_hl(0, "Pmenu", {
    -- 	bg = catppuccin.base,
    -- 	fg = catppuccin.text,
    -- })

    -- vim.api.nvim_set_hl(0, "PmenuSel", {
    -- 	bg = catppuccin.base,
    -- 	fg = catppuccin.text,
    -- })

    -- vim.api.nvim_set_hl(0, "WinSeparator", {
    -- 	fg = catppuccin.blue,
    -- })
  end,
}
