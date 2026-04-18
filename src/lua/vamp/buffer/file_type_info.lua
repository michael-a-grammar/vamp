local M = {}

function M.type()
  local buffer_number = vim.api.nvim_get_current_buf()
  local file_type = vim.filetype.match({ buf = buffer_number })

  if not file_type then
    return false
  end

  return file_type
end

function M.extension()
  return vim.fn.expand("%:e")
end

return M
