-- stylua: ignore start
local new_autocmd = require("vamp.lib.new_autocmd")
local safely      = require("vamp.lib.safely")
-- stylua: ignore end

vim.g.mapleader = ' '

-- stylua: ignore start
vim.o.mouse       = "a"
vim.o.mousescroll = "ver:5,hor:10"
vim.o.switchbuf   = "usetab"
vim.o.undofile    = true
-- stylua: ignore end

vim.o.shada = "'100,<50,s10,:1000,/100,@100,h"

vim.cmd('filetype plugin indent on')

if vim.fn.exists('syntax_on') ~= 1 then
  vim.cmd('syntax enable')
end

-- stylua: ignore start
vim.o.breakindent    = true
vim.o.breakindentopt = "list:-1"
vim.o.colorcolumn    = "+1"
vim.o.cursorline     = true
vim.o.laststatus     = 3
vim.o.linebreak      = true
vim.o.list           = true
vim.o.number         = true
vim.o.pumborder      = "single"
vim.o.pumheight      = 10
vim.o.pummaxwidth    = 100
vim.o.ruler          = false
vim.o.shortmess      = "CFOSWaco"
vim.o.showmode       = false
vim.o.signcolumn     = "yes"
vim.o.splitbelow     = true
vim.o.splitkeep      = "screen"
vim.o.splitright     = true
vim.o.winborder      = "single"
vim.o.wrap           = false
-- stylua: ignore end

vim.o.cursorlineopt = 'screenline,number'

-- stylua: ignore start
vim.o.fillchars = "eob: ,fold:╌"
vim.o.listchars = "extends:…,nbsp:␣,precedes:…,tab:> "
-- stylua: ignore end

vim.o.foldlevel = 10
vim.o.foldmethod = 'indent'
vim.o.foldnestmax = 10
vim.o.foldtext = ''
-- stylua: ignore end

-- stylua: ignore start
vim.o.autoindent    = true
vim.o.expandtab     = true
vim.o.formatoptions = "rqnl1j"
vim.o.ignorecase    = true
vim.o.incsearch     = true
vim.o.infercase     = true
vim.o.shiftwidth    = 2
vim.o.smartcase     = true
vim.o.smartindent   = true
vim.o.spelloptions  = "camel"
vim.o.tabstop       = 2
vim.o.virtualedit   = "block"
-- stylua: ignore end

vim.o.iskeyword = '@,48-57,_,192-255,-'

vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- stylua: ignore start
vim.o.complete        = ".,w,b,kspell"
vim.o.completeopt     = "menuone,noselect,fuzzy,nosort"
vim.o.completetimeout = 100
-- stylua: ignore end

vim.o.spelllang = 'en_gb,en,it,es'

new_autocmd('FileType', nil, function()
  vim.cmd('setlocal formatoptions-=c formatoptions-=o')
end, "Improved 'formatoptions'")

local diagnostic_opts = {
  -- stylua: ignore start
  update_in_insert = false,
  virtual_lines    = false,
  -- stylua: ignore end

  signs = {
    priority = 9999,

    severity = {
      min = 'WARN',
      max = 'ERROR',
    },
  },

  underline = {
    severity = {
      min = 'HINT',
      max = 'ERROR',
    },
  },

  virtual_text = {
    current_line = true,

    severity = {
      min = 'ERROR',
      max = 'ERROR',
    },
  },
}

safely.later(function()
  vim.diagnostic.config(diagnostic_opts)
end)
