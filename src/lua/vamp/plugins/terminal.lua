return {
  'rebelot/terminal.nvim',

  opts = {
    autoclose = true,
  },

  config = function(_, opts)
    require('terminal').setup(opts)

    local terminal_mappings = require('terminal.mappings')

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>rc',
      terminal_mappings.run(nil, {
        layout = {
          open_cmd = 'enew',
        },
      }),
      { desc = 'New terminal', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>rr',
      terminal_mappings.toggle({ open_cmd = 'botright vnew' }),
      { desc = 'Toggle terminal', noremap = true }
    )

    -- vim.keymap.set(
    --   { 'n', 'x' },
    --   '<leader>rs',
    --   term_map.operator_send,
    --   { expr = true }
    -- )
    --
    -- vim.keymap.set('n', '<leader>ro', terminal_mappings.toggle)
    -- vim.keymap.set('n', '<leader>rO', term_map.toggle({ open_cmd = 'enew' }))
    -- -- vim.keymap.set('n', '<leader>rr', term_map.run)
    --
    -- vim.keymap.set(
    --   'n',
    --   '<leader>rR',
    --   term_map.run(nil, { layout = { open_cmd = 'enew' } })
    -- )
    --
    -- vim.keymap.set('n', '<leader>rk', term_map.kill)
    -- vim.keymap.set('n', '<leader>r]', term_map.cycle_next)
    -- vim.keymap.set('n', '<leader>r[', term_map.cycle_prev)
    --
    -- vim.keymap.set(
    --   'n',
    --   '<leader>rl',
    --   term_map.move({ open_cmd = 'belowright vnew' })
    -- )
    --
    -- vim.keymap.set(
    --   'n',
    --   '<leader>rL',
    --   term_map.move({ open_cmd = 'botright vnew' })
    -- )
    --
    -- vim.keymap.set(
    --   'n',
    --   '<leader>rh',
    --   term_map.move({ open_cmd = 'belowright new' })
    -- )
    --
    -- vim.keymap.set(
    --   'n',
    --   '<leader>rH',
    --   term_map.move({ open_cmd = 'botright new' })
    -- )
    --
    -- vim.keymap.set('n', '<leader>rf', term_map.move({ open_cmd = 'float' }))

    vim.api.nvim_create_autocmd({
      'BufWinEnter',
      'WinEnter',
      'TermOpen',
    }, {
      callback = function(args)
        if vim.startswith(vim.api.nvim_buf_get_name(args.buf), 'term://') then
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.signcolumn = 'no'

          vim.print('hello')

          vim.print(vim.b.filetype)
          vim.print(vim.b.buftype)

          vim.print('goodbye')

          vim.cmd('startinsert')
        end
      end,
    })
  end,
}
