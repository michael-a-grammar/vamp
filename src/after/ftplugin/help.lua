vim.keymap.set('n', '<CR>', '<C-]>', { buffer = 0 })

vim.keymap.set({ 'n', 'x' }, 'q', '<Cmd>close<CR>', { buffer = 0 })

vim.keymap.set(
  { 'n', 'x' },
  '<Leader>mn',
  [[/|.\{-}|<CR>]],
  { buffer = 0, desc = 'Next help tag' }
)

vim.keymap.set(
  { 'n', 'x' },
  '<Leader>mp',
  [[?|.\{-}|<CR>]],
  { buffer = 0, desc = 'Previous help tag' }
)

vim.b.miniclue_config = {
  clues = {
    {
      {
        mode = 'n',
        keys = '<Leader>m',
        desc = '+Help (local leader)',
      },
    },
  },
}
