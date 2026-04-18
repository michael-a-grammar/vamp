return {
  "sindrets/diffview.nvim",

  config = true,

  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  keys = {
    {
      "<leader>ngh",
      "<cmd>DiffviewFileHistory %<cr>",
      desc = "File history",
      mode = { "n", "x" },
    },
  },
}
