return setmetatable({}, {
  __call = function(_, event, pattern, callback, desc)
    local group = vim.api.nvim_create_augroup("vamp", {
      clear = false,
    })

    vim.api.nvim_create_autocmd(event, {
      group = group,
      pattern = pattern,
      callback = callback,
      desc = desc,
    })
  end,
})
