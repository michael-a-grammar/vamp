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
  { "n", "x" },
  "<c-down>",
  "<c-w>j",
  { desc = "Move to bottom window", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<c-up>",
  "<c-w>w",
  { desc = "Move to top window", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<c-left>",
  "<c-w>h",
  { desc = "Move to left window", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<c-right>",
  "<c-w>l",
  { desc = "Move to right window", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<pagedown>",
  "<c-d>zzzv",
  { desc = "Scroll down and centre", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<pageup>",
  "<c-u>zzzv",
  { desc = "Scroll up and centre", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<c-d>",
  "<c-d>zzzv",
  { desc = "Scroll down and centre", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<c-u>",
  "<c-u>zzzv",
  { desc = "Scroll up and centre", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<c-p>",
  "<c-d>zzzv",
  { desc = "Scroll down and centre", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<c-f>",
  "<c-u>zzzv",
  { desc = "Scroll up and centre", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "0",
  "g0",
  { desc = "Beginning of line", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "^",
  "g^",
  { desc = "Start of line", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "$",
  "g$",
  { desc = "End of line", noremap = true }
)

vim.keymap.set({ "n", "x" }, "n", "nzzzv", { desc = "Next match and centre" })

vim.keymap.set(
  { "n", "x" },
  "N",
  "Nzzzv",
  { desc = "Previous match and centre" }
)

vim.keymap.set(
  { "n", "x" },
  "H",
  "g^",
  { desc = "Start of line", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "L",
  "g$",
  { desc = "End of line", noremap = true }
)

vim.keymap.set({ "n", "x" }, "U", "<c-r>", { desc = "Redo", noremap = true })

-- vim.keymap.set(
--   { "n", "x" },
--   "k",
--   vim.lsp.buf.hover,
--   { desc = "Hover", noremap = true }
-- )

vim.keymap.set(
  { "n", "x" },
  "<leader>!",
  ":!",
  { desc = "Shell command", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader><tab>",
  "<c-^>",
  { desc = "Previous buffer", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>di",
  vim.diagnostic.open_float,
  { desc = "Diagnostic info", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>dl",
  vim.diagnostic.setloclist,
  { desc = "Set loclist with diagnostics", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>dn",
  vim.diagnostic.goto_next,
  { desc = "Next diagnostic", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>dp",
  vim.diagnostic.goto_prev,
  { desc = "Previous diagnostic", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>ea",
  vim.lsp.buf.code_action,
  { desc = "Action", noremap = true }
)

vim.keymap.set({ "n", "x" }, "<leader>ef", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format", noremap = true })

vim.keymap.set(
  { "n", "x" },
  "<leader>ek",
  vim.lsp.buf.hover,
  { desc = "Hover", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>er",
  vim.lsp.buf.rename,
  { desc = "Rename", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>es",
  vim.lsp.buf.signature_help,
  { desc = "Signature help", noremap = true }
)

vim.keymap.set({ "n", "x" }, "<leader>et", function()
  vim.lsp.buf.codelens.run()
end, { desc = "Run test", noremap = true })

vim.keymap.set(
  { "n", "x" },
  "<leader>fi",
  "<c-i>zzzv",
  { desc = "Forwards", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>fo",
  "<c-o>zzzv",
  { desc = "Backwards", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>fqn",
  "<cmd>cnext<cr>zzzv",
  { desc = "Quickfix next", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>fqp",
  "<cmd>cprevious<cr>zz",
  { desc = "Quickfix previous", noremap = true }
)

local function toggle(opt_name)
  vim.opt[opt_name] = not vim.opt[opt_name]:get()
end

vim.keymap.set({ "n", "x" }, "<leader>kh", function()
  toggle("hlsearch")
end, { desc = "Toggle highlighted search results", noremap = true })

vim.keymap.set({ "n", "x" }, "<leader>ki", function()
  toggle("incsearch")
end, { desc = "Toggle incremental search", noremap = true })

vim.keymap.set({ "n", "x" }, "<leader>ks", function()
  toggle("spell")
end, { desc = "Toggle spelling", noremap = true })

vim.keymap.set(
  { "n", "x" },
  "<leader>ndd",
  "<cmd>bprevious | bdelete #<cr>",
  { desc = "Close buffer", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>ndf",
  "<cmd>bprevious | bdelete! #<cr>",
  { desc = "" .. " Close buffer", noremap = true }
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
  "<leader>p%",
  ":%s/",
  { desc = "Substitute within buffer", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>p/",
  ":s/",
  { desc = "Substitute within line", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>pd",
  "<c-x>",
  { desc = "Decrement number", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>pi",
  "<c-a>",
  { desc = "Increment number", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>qf",
  "<cmd>quitall!<cr>",
  { desc = "" .. " Quit all", noremap = true }
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
  "<leader>tc",
  "<cmd>new<cr>",
  { desc = "New buffer", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>th",
  "<cmd>horizontal ball<cr>",
  { desc = "Open buffers in horizontal splits", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>tv",
  "<cmd>vertical ball<cr>",
  { desc = "Open buffers in vertical splits", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>ty",
  "<cmd>tab ball<cr>",
  { desc = "Open buffers in tabs", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>w<down>",
  "<c-w>j",
  { desc = "Move to bottom window", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>w<up>",
  "<c-w>w",
  { desc = "Move to top window", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>w<left>",
  "<c-w>h",
  { desc = "Move to left window", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>w<right>",
  "<c-w>l",
  { desc = "Move to right window", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>w=",
  "<c-w><c-=>",
  { desc = "Equalise window size", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wd",
  "<cmd>close<cr>",
  { desc = "Close window", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>we",
  "<c-w><c-x>",
  { desc = "Exchange window", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wt",
  "<cmd>tab split<cr>",
  { desc = "Open window in new tab", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>ww",
  "<c-w><c-p>",
  { desc = "Previous window", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wx",
  "<cmd>only<cr>",
  { desc = "Close other windows", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wch",
  "<cmd>horizontal botright new<cr>",
  { desc = "Split window horizontally", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wcv",
  "<cmd>vertical botright new<cr>",
  { desc = "Split window vertically", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wmn",
  "<c-w><c-H>",
  { desc = "Move window to left", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wme",
  "<c-w><c-J>",
  { desc = "Move window to bottom", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wmi",
  "<c-w><c-K>",
  { desc = "Move window to top", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wmo",
  "<c-w>L",
  { desc = "Move window to right", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wnn",
  "<c-w><c-h>",
  { desc = "Navigate to left window", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wne",
  "<c-w><c-j>",
  { desc = "Navigate to bottom window", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wni",
  "<c-w><c-k>",
  { desc = "Navigate to top window", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wno",
  "<c-w><c-l>",
  { desc = "Navigate to right window", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wof",
  "<c-w><c-R>",
  { desc = "Rotate window upwards/leftwards", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wop",
  "<c-w><c-r>",
  { desc = "Rotate window downwards/rightwards", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wrn",
  "<c-w><c-<>",
  { desc = "Decrease window width", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wre",
  "<c-w><c-+>",
  { desc = "Increase window height", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wri",
  "<c-w><c-->",
  { desc = "Decrease window height", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wro",
  "<c-w><c->>",
  { desc = "Increase window width", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wrh",
  "<c-w><c-_>",
  { desc = "Maximise window height", noremap = true }
)

vim.keymap.set(
  { "n", "x" },
  "<leader>wrw",
  "<c-w><c-|>",
  { desc = "Maximise window width", noremap = true }
)

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
end, { desc = "󰭟", noremap = true })

vim.keymap.set(
  "t",
  "<c-g>",
  "<c-\\><c-n>",
  { desc = "Normal mode", noremap = true }
)

vim.keymap.set(
  "x",
  "<leader>ps",
  "<cmd>'<,'>sort<cr>",
  { desc = "Sort", noremap = true }
)

vim.keymap.set(
  "x",
  "<leader>pv",
  ":'<,'>s/",
  { desc = "Substitute within visual selection", noremap = true }
)
