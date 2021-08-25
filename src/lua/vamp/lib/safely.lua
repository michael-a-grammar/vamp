local M = {}

local minimisc = require('mini.misc')

local function safely(when, func)
  minimisc.safely(when, func)
end

M.now = function(func)
  safely('now', func)
end

M.later = function(func)
  safely('later', func)
end

M.now_if_args = vim.fn.argc(-1) > 0 and M.now or M.later

M.on_event = function(event, func)
  safely('event:' .. event, func)
end

M.on_filetype = function(filetype, func)
  safely('filetype:' .. filetype, func)
end

return M
