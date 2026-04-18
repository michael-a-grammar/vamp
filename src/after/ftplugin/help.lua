local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set(
  { "n", "x" },
  "<cr>",
  "<c-]>",
  { desc = "Go to help tag", noremap = true, buffer = bufnr }
)

vim.keymap.set(
  { "n", "x" },
  "q",
  "<cmd>close<cr>",
  { desc = "Close help", noremap = true, buffer = bufnr }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>mn",
  [[/|.\{-}|<cr>]],
  { desc = "Next help tag", noremap = true, buffer = bufnr }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>mp",
  [[?|.\{-}|<cr>]],
  { desc = "Previous help tag", noremap = true, buffer = bufnr }
)

local to_add = {
  {
    mode = {
      "n",
      "x",
    },

    {
      "<leader>m",
      group = "󰋖",
    },
  },
}

local which_key = require("which-key")

which_key.add(to_add)
