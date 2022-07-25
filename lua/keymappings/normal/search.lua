return function()
  local map = require'milque.cartographer'.with['n_leader_/']

  map()
  .use_i()
  .rhs
  .cmd('set noincsearch')
  .exe()

  map()
  .use_t()
  .rhs
  .cmd('nohlsearch')
  .exe()
end
