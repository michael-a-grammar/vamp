return function()
  local map = require'bundled.cartographer'.map

  map(function()
    nx_leader_with 'x' {
      'a', plug 'EasyAlign', 'Align'
    }
  end)
end
