return {
  'bfredl/nvim-miniyank',

  init = function()
    local map = require'elden.cartographer'.map

    map(function()
      nx_leader_with 'p' {
        'n', plug('miniyank-cycle'),     'Yank ring forwards',
        'N', plug('miniyank-cycleback'), 'Yank ring backwards',
        'p', plug('miniyank-startput'),  'Yank ring put',
        'P', plug('miniyank-startPut'),  'Yank ring Put'
      }
    end)
  end,
}
