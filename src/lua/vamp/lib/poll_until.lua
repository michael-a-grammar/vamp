return setmetatable({}, {
  __call = function(_, condition, on_complete)
    local timer = vim.uv.new_timer()

    if timer ~= nil then
      timer:start(0, 100, function()
        if condition() then
          timer:stop()
          timer:close()

          vim.schedule(on_complete)
        end
      end)
    end
  end,
})
