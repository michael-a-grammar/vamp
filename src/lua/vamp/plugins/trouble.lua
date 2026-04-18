return {
  "folke/trouble.nvim",

  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  opts = {
    action_keys = {
      hover = "k",
      jump_close = "g",
      next = "p",
      open_code_href = "c",
      open_split = "h",
      open_tab = "t",
      open_vsplit = "v",
      previous = "f",
      switch_severity = "w",
      toggle_mode = "m",
      toggle_preview = "o",
    },

    fold_closed = "",
    fold_open = "",
  },

  config = function(_, opts)
    local trouble = require("trouble")

    trouble.setup(opts)

    vim.keymap.set({ "n", "x" }, "<leader>dd", function()
      trouble.toggle("diagnostics")
    end, { desc = "Diagnostics", noremap = true })

    vim.keymap.set({ "n", "x" }, "<leader>ee", function()
      trouble.toggle("lsp_definitions")
    end, { desc = "Definitions", noremap = true })

    vim.keymap.set({ "n", "x" }, "<leader>eu", function()
      trouble.toggle("lsp_references")
    end, { desc = "References", noremap = true })

    vim.keymap.set({ "n", "x" }, "<leader>ey", function()
      trouble.toggle("lsp_type_definitions")
    end, { desc = "Type definitions", noremap = true })

    vim.keymap.set({ "n", "x" }, "<leader>fl", function()
      trouble.toggle("loclist")
    end, { desc = "Loclist", noremap = true })

    vim.keymap.set({ "n", "x" }, "<leader>fqq", function()
      trouble.toggle("quickfix")
    end, { desc = "Quickfix", noremap = true })

    vim.keymap.set({ "n", "x" }, "gd", function()
      trouble.toggle("lsp_definitions")
    end, { desc = "Definitions", noremap = true })

    vim.keymap.set({ "n", "x" }, "gr", function()
      trouble.toggle("lsp_references")
    end, { desc = "References", noremap = true })

    vim.keymap.set({ "n", "x" }, "<leader>kt", function()
      trouble.toggle()
    end, { desc = "Toggle trouble", noremap = true })

    local catppuccin =
      require("catppuccin.palettes").get_palette(_G.catppuccin_theme)

    vim.api.nvim_set_hl(0, "TroubleNormal", {
      bg = catppuccin.base,
    })
  end,
}
