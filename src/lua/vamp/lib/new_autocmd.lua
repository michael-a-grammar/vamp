return setmetatable({}, {
  __call = function(_, event, pattern, callback, desc)
    local group = vim.api.nvim_create_augroup('vamp', {
      clear = false,
    })

    vim.api.nvim_create_autocmd(event, {
      -- stylua: ignore start
      group    = group,
      pattern  = pattern,
      callback = callback,
      desc     = desc,
      -- stylua: ignore end
    })
  end,
})
