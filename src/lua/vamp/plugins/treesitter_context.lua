return {
  "nvim-treesitter/nvim-treesitter-context",

  config = function(_, _)
    require("treesitter-context").setup()

    vim.keymap.set(
      { "n", "x" },
      "<leader>kc",
      "<cmd>TSContextToggle<cr>",
      { desc = "Toggle treesitter context", noremap = true }
    )

    for index = 1, 9, 1 do
      local treesitter_context_index = tostring(index)
      local keymap_index = index == 1 and "c" or treesitter_context_index

      vim.keymap.set({ "n", "x" }, "<leader>nc" .. keymap_index, function()
        require("treesitter-context").go_to_context(treesitter_context_index)
      end, {
        desc = "Go to context " .. treesitter_context_index,
        noremap = true,
      })
    end

    local catppuccin =
      require("catppuccin.palettes").get_palette(_G.catppuccin_theme)

    vim.api.nvim_set_hl(0, "TreesitterContextBottom", {
      sp = catppuccin.blue,
      underline = true,
    })
  end,
}
