local M = {}

local function expand(expression)
  return function()
    return vim.fn.expand(expression)
  end
end

M.directory = expand("%:p:h")
M.filename = expand("%:p:t")
M.full = expand("%:p")

return M
