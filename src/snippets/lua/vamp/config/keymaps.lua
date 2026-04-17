vim.keymap.set(
  "n",
  "[p",
  '<Cmd>exe "iput! " . v:register<CR>',
  { desc = "Paste above", noremap = true }
)

vim.keymap.set(
  "n",
  "]p",
  '<Cmd>exe "iput " . v:register<CR>',
  { desc = "Paste below", noremap = true }
)

vim.keymap.set({ "n", "x" }, "U", "<c-r>", { desc = "Redo", noremap = true })

vim.keymap.set(
  { "n", "x" },
  "<leader><tab>",
  "<c-^>",
  { desc = "Previous buffer", noremap = true }
)

vim.keymap.set({ "n", "x" }, "<leader>nff", function()
  vim.fn.setreg("+", vim.fn.expand("%:p:t"))
end, { desc = "Copy filename", noremap = true })

vim.keymap.set({ "n", "x" }, "<leader>nfp", function()
  vim.fn.setreg("+", vim.fn.expand("%:p:h"))
end, { desc = "Copy directory path", noremap = true })

vim.keymap.set({ "n", "x" }, "<leader>nfr", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Copy full path", noremap = true })

vim.keymap.set(
  { "n", "x" },
  "<leader>qf",
  "<cmd>quitall!<cr>",
  { desc = " " .. "Quit all", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>qq",
  "<cmd>quitall<cr>",
  { desc = "Quit all", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>qw",
  "<cmd>wqall<cr>",
  { desc = "Write and quit all", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>rs",
  "<cmd>horizontal term<cr>",
  { desc = "Terminal (horizontal)", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>rr",
  "<cmd>vertical term<cr>",
  { desc = "Terminal (vertical)", noremap = true }
)

vim.keymap.set({ "n", "x" }, "<leader>ts", function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end, { desc = "New scratch buffer", noremap = true })

vim.keymap.set(
  { "n", "x" },
  "<leader>yc",
  "<cmd>tabnew<cr>",
  { desc = "New tab", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>yd",
  "<cmd>tabclose<cr>",
  { desc = "Close tab", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>yf",
  "<cmd>tabfirst<cr>",
  { desc = "First tab", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>yl",
  "<cmd>tablast<cr>",
  { desc = "Last tab", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>yn",
  "<cmd>tabnext<cr>",
  { desc = "Next tab", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>yp",
  "<cmd>tabprevious<cr>",
  { desc = "Previous tab", noremap = true }
)

vim.keymap.set({ "n", "x" }, "<leader>zv", function()
  local is_vamp = string.find(vim.loop.cwd() or "", ".+/vamp.-")

  if is_vamp then
    vim.cmd("wa")
  end

  vim.cmd("!vamp")
  vim.cmd("qa")
end, { desc = "󰭟 ", noremap = true })

vim.keymap.set("i", "jj", "<esc>", { desc = "Normal mode", noremap = false })

vim.keymap.set(
  "c",
  "<a-left>",
  "<c-left>",
  { desc = "Word backwards", noremap = true }
)

vim.keymap.set(
  "c",
  "<a-right>",
  "<c-right>",
  { desc = "Word forwards", noremap = true }
)

vim.keymap.set(
  "t",
  "<c-bs>",
  "<c-\\><c-n>",
  { desc = "Normal mode", noremap = true }
)
