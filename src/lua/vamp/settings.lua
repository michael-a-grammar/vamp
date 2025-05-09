vim.opt.background = "dark"

vim.opt.clipboard:append("unnamed")

vim.opt.spelllang = { "en_gb", "en", "it", "es" }

vim.opt.encoding = "utf-8"

vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.fixendofline = true

vim.opt.list = false

vim.opt.listchars = {
  eol = "¬",
  extends = ">",
  precedes = "<",
  space = "␣",
  tab = ">·",
  trail = "~",
}

vim.opt.hidden = true

vim.opt.switchbuf = {
  "uselast",
}

vim.opt.hlsearch = true
vim.opt.splitbelow = true
vim.opt.wrapscan = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.autochdir = false

vim.opt.path:append("**")

vim.opt.wildignore = {
  "*/.git/*",
  "*/.idea/*",
  "*/.meteor/*",
  "*/node_modules/*",
}

vim.opt.autoindent = true
vim.opt.breakindent = true

vim.opt.startofline = false
vim.opt.wrap = true

vim.opt.completeopt = {
  "menu",
  "menuone",
  "noinsert",
  "noselect",
  "preview",
}

vim.opt.history = 1000
vim.opt.wildmenu = true

vim.opt.laststatus = 3

vim.opt.shortmess:append("c")
vim.opt.showcmd = true
vim.opt.showmode = false
vim.opt.ruler = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

vim.opt.cursorline = true
vim.opt.matchtime = 2
vim.opt.showmatch = true

vim.opt.timeout = true
vim.opt.timeoutlen = 800
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 80

vim.opt.sessionoptions:append("globals")

vim.opt.backup = true
vim.opt.backupcopy = "auto"
vim.opt.backupdir:remove(".")
vim.opt.updatetime = 300
vim.opt.writebackup = true

vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 1000

vim.opt.concealcursor = "nvic"
vim.opt.conceallevel = 0

vim.opt.visualbell = true

vim.api.nvim_exec2("runtime macros/matchit.vim", {})

vim.opt.mouse = "a"
vim.opt.termguicolors = true

vim.diagnostic.config({
  float = {
    border = "rounded",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.HINT] = "󰮥",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.WARN] = "",
    },
  },
})

local events_augroup = vim.api.nvim_create_augroup("events", {})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = events_augroup,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.g["mapleader"] = vim.api.nvim_replace_termcodes("<space>", true, true, true)
vim.g["maplocalleader"] = vim.api.nvim_replace_termcodes("\\", true, true, true)
