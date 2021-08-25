vim.keymap.set({ 'n', 'x' }, '<C-f>', '<C-d>zzzv', { noremap = true })

vim.keymap.set({ 'n', 'x' }, '<C-p>', '<C-u>zzzv', { noremap = true })

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

vim.keymap.set('n', 'U', '<C-r>', { noremap = true })

vim.keymap.set(
  'n',
  '<Leader><Tab>',
  '<C-^>',
  { desc = 'Alternative buffer', noremap = true }
)

vim.keymap.set('n', '<Leader>kt', function()
  if vim.o.showtabline == 0 then
    vim.o.showtabline = 1
  else
    vim.o.showtabline = 0
  end

  vim.cmd('setlocal showtabline')
end, { desc = 'Toggle tabline', noremap = true })

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
  { desc = 'Open buffer in new tab', noremap = true }
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
  '<Leader>rs',
  '<Cmd>horizontal term<CR>',
  { desc = 'Terminal (horizontal)', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>rr',
  '<Cmd>vertical term<CR>',
  { desc = 'Terminal (vertical)', noremap = true }
)

vim.keymap.set('n', '<Leader>ts', function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end, { desc = 'New scratch buffer', noremap = true })

vim.keymap.set('n', '<Leader>vv', function()
  local is_vamp = string.find(vim.loop.cwd() or '', '.+/vamp.-')

  if is_vamp then
    vim.cmd('wall')
  end

  vim.cmd('!vamp')
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
  { desc = 'New tab', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>yd',
  '<Cmd>tabclose<CR>',
  { desc = 'Close tab', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>yf',
  '<Cmd>tabfirst<CR>',
  { desc = 'First tab', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>yl',
  '<Cmd>tablast<CR>',
  { desc = 'Last tab', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>yn',
  '<Cmd>tabnext<CR>',
  { desc = 'Next tab', noremap = true }
)

vim.keymap.set(
  'n',
  '<Leader>yp',
  '<Cmd>tabprevious<CR>',
  { desc = 'Previous tab', noremap = true }
)

vim.keymap.set('i', 'jj', '<Esc>', { noremap = false })

vim.keymap.set('c', '<M-Left>', '<C-Left>', { noremap = true })

vim.keymap.set('c', '<M-Right>', '<C-Right>', { noremap = true })

vim.keymap.set('t', '<C-g>', '<C-\\><C-n>', { noremap = true })
