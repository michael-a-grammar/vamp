return setmetatable({}, {
  __call = function(_, plugin_name, kinds, callback, desc)
    require('vamp.lib.new_autocmd')('PackChanged', '*', function(event)
      local name, kind = event.data.spec.name, event.data.kind

      if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
        return
      end

      if not event.data.active then
        vim.cmd.packadd(plugin_name)
      end

      callback(event.data)
    end, desc)
  end,
})
