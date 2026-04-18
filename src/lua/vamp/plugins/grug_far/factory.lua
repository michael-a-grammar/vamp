local M = {}

function M.open(opts)
  opts = opts or {}

  local file_paths = require("vamp.buffer.file_paths")
  local file_type_info = require("vamp.buffer.file_type_info")

  local prefills = {}

  prefills.flags = "--ignore-case"

  if opts.search_current_word then
    prefills.search = vim.fn.expand("<cword>")
  end

  if opts.paths_current_file then
    prefills.paths = file_paths.full()
  end

  if opts.paths_current_file_directory then
    prefills.paths = file_paths.directory()
  end

  if opts.files_filter_current_buffer_file_type then
    prefills.filesFilter = "*." .. file_type_info.extension()
  end

  require("grug-far").open({
    prefills = prefills,
    staticTitle = "󰛔",
    transient = true,
  })
end

return M
