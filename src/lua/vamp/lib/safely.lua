local M = {}

local mini_misc = require("mini.misc")

local safely = function(when, fn)
  mini_misc.safely(when, fn)
end

M.now = function(fn)
  safely("now", fn)
end

M.later = function(fn)
  safely("later", fn)
end

M.now_if_args = vim.fn.argc(-1) > 0 and M.now or M.later

M.on_event = function(event, fn)
  safely("event:" .. event, fn)
end

M.on_filetype = function(filetype, fn)
  safely("filetype:" .. filetype, fn)
end

return M
