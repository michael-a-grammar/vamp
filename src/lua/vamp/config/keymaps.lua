local map = require('vamp.lib.cartographer').map

-- stylua: ignore start
map(function()
  nx {
    ctrl 'f', ctrl 'd' :with 'zzzv', 'Scroll down',
    ctrl 'p', ctrl 'u' :with 'zzzv', 'Scroll up',
  }

  n {
  }

  n_with 'l' {
    'k', vim.diagnostic.open_float, 'Diagnostic open float',
  }

  n_with 'la' {
    'a', vim.lsp.buf.code_action, 'Code actions!',
    'c', vim.lsp.codelens.run,    'Codelens run!',
    'r', vim.lsp.buf.rename,      'Rename',
  }

  n_leader {
    tab, ctrl '^', 'Alternative buffer!',
  }

  n_leader_with 'k' {
    't',
    function()
      if vim.o.showtabline == 0 then
        vim.o.showtabline = 1
      else
        vim.o.showtabline = 0
      end
      vim.cmd('setlocal showtabline')
    end,
    'Toggle tabline!',
  }
end)
-- stylua: ignore end

vim.keymap.set(
  'n',
  '[p',
  '<Cmd>exe "iput! " . v:register<CR>',
  { desc = 'Paste above', noremap = true }
)

vim.keymap.set(
  'n',
  ']p',
  '<Cmd>exe "iput " . v:register<CR>',
  { desc = 'Paste below', noremap = true }
)

-- vim.keymap.set(
--   'n',
--   'laa',
--   vim.lsp.buf.code_action,
--   { desc = 'Code actions', noremap = true }
-- )

-- vim.keymap.set(
--   'n',
--   'lac',
--   vim.lsp.codelens.run,
--   { desc = 'Codelens', noremap = true }
-- )

-- vim.keymap.set(
--   'n',
--   'lar',
--   vim.lsp.buf.rename,
--   { desc = 'Rename', noremap = true }
-- )

-- vim.keymap.set(
--   'n',
--   'lk',
--   vim.diagnostic.open_float,
--   { desc = 'Diagnostic open float', noremap = true }
-- )

vim.keymap.set('n', 'k', vim.lsp.buf.hover, { desc = 'Hover', noremap = true })

vim.keymap.set('n', 'U', '<C-r>', { noremap = true })

vim.keymap.set('n', '<BS>c', '`.', { desc = 'Latest change', noremap = true })

vim.keymap.set(
  'n',
  '<BS>i',
  '`^',
  { desc = 'Latest insert position', noremap = true }
)

vim.keymap.set('n', '<BS>n', '<C-i>', { desc = 'Newer', noremap = true })

vim.keymap.set('n', '<BS>p', '<C-o>', { desc = 'Older', noremap = true })

-- vim.keymap.set(
--   'n',
--   '<Leader><Tab>',
--   '<C-^>',
--   { desc = 'Alternative buffer', noremap = true }
-- )

-- vim.keymap.set('n', '<Leader>kt', function()
--   if vim.o.showtabline == 0 then
--     vim.o.showtabline = 1
--   else
--     vim.o.showtabline = 0
--   end
--
--   vim.cmd('setlocal showtabline')
-- end, { desc = 'Toggle tabline', noremap = true })

vim.keymap.set('n', '<Leader>nff', function()
  vim.fn.setreg(vim.v.register, vim.fn.expand('%'))
end, { desc = 'Yank relative path', noremap = true })

vim.keymap.set('n', '<Leader>nfn', function()
  vim.fn.setreg(vim.v.register, vim.fn.expand('%:t'))
end, { desc = 'Yank filename', noremap = true })

vim.keymap.set('n', '<Leader>nfp', function()
  vim.fn.setreg(vim.v.register, vim.fn.expand('%:p'))
end, { desc = 'Yank full path', noremap = true })

vim.keymap.set(
  'n',
  '<Leader>nt',
  '<Cmd>tab split<CR>',
  { desc = 'Open buffer in new tabpage', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>ny',
  '<Cmd>%y<CR>',
  { desc = 'Yank buffer', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>qf',
  '<Cmd>quitall!<CR>',
  { desc = 'Force quit all', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>qq',
  '<Cmd>quitall<CR>',
  { desc = 'Quit all', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>qr',
  '<Cmd>restart<CR>',
  { desc = 'Restart', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>qw',
  '<Cmd>wqall<CR>',
  { desc = 'Write and quit all', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>rag',
  '<Cmd>tabnew | terminal lazygit<CR>',
  { desc = 'Lazygit', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>rad',
  '<Cmd>tabnew | terminal lazydocker<CR>',
  { desc = 'Lazydocker', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>rc',
  '<Cmd>terminal<CR>',
  { desc = 'Terminal (current window)', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>rs',
  '<Cmd>horizontal terminal<CR>',
  { desc = 'Terminal (horizontal split)', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>rr',
  '<Cmd>vertical terminal<CR>',
  { desc = 'Terminal (vertical split)', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>ry',
  '<Cmd>tabnew | terminal<CR>',
  { desc = 'Terminal (new tabpage)', noremap = true }
)

vim.keymap.set('n', '<Leader>ts', function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end, { desc = 'New scratch buffer', noremap = true })

vim.keymap.set('n', '<Leader>vv', function()
  local is_vamp = string.find(vim.uv.cwd() or '', '.+/vamp.-')

  if is_vamp then
    vim.cmd('wall')
  end

  vim.system({ 'fish', '-c', 'vamp' }):wait()

  vim.cmd('restart')
end, { desc = 'Vamp', noremap = true })

vim.keymap.set(
  'n',
  '<Leader>wd',
  '<Cmd>close<CR>',
  { desc = 'Close window', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>wo',
  '<Cmd>only<CR>',
  { desc = 'Close other windows', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>ws',
  '<Cmd>botright split<CR>',
  { desc = 'Split window horizontally', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>wv',
  '<Cmd>botright vsplit<CR>',
  { desc = 'Split window vertically', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>ww',
  '<C-w><C-w>',
  { desc = 'Change to previous window', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>yc',
  '<Cmd>tabnew<CR>',
  { desc = 'New tabpage', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>yd',
  '<Cmd>tabclose<CR>',
  { desc = 'Close tabpage', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>yf',
  '<Cmd>tabfirst<CR>',
  { desc = 'First tabpage', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>yl',
  '<Cmd>tablast<CR>',
  { desc = 'Last tabpage', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>ymf',
  '<Cmd>0tabmove<CR>',
  { desc = 'Move tabpage to the first', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>yml',
  '<Cmd>$tabmove<CR>',
  { desc = 'Move tabpage to the last', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>ymn',
  '<Cmd>tabmove +<CR>',
  { desc = 'Move tabpage to the right', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>ymp',
  '<Cmd>tabmove -<CR>',
  { desc = 'Move tabpage to the left', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>yn',
  '<Cmd>tabnext<CR>',
  { desc = 'Next tabpage', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>yp',
  '<Cmd>tabprevious<CR>',
  { desc = 'Previous tabpage', noremap = true }
)

vim.keymap.set('i', 'jj', '<Esc>', { noremap = false })

vim.keymap.set('c', '<M-Left>', '<C-Left>', { noremap = true })

vim.keymap.set('c', '<M-Right>', '<C-Right>', { noremap = true })

vim.keymap.set('t', '<C-g>', '<C-\\><C-n>', { noremap = true })
