return function()
  local map = require'bundled.cartographer'.map

  map(function()
    nx_leader_with 'f' {
      'u', exe 'UndotreeToggle', 'Undo tree'
    }
  end)
end
