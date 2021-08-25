local new_autocmd = require('vamp.lib.new_autocmd')

local filetype_block_list = {
  'help',
  'minipick',
}

local last_directory = ''

new_autocmd('DirChanged', '*', function(args)
  local new_directory = args.file

  if
    not vim.list_contains(filetype_block_list, vim.bo.filetype)
    and new_directory ~= last_directory
  then
    vim.notify('Directory changed to ' .. new_directory .. ' ')

    last_directory = new_directory
  end
end)

new_autocmd('TermOpen', '*', function(args)
  vim.b.miniindentscope_disable = true
end)
