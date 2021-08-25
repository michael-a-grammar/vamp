return {
  on_attach = function(client, buf_id)
    client.server_capabilities.completionProvider.triggerCharacters = {
      '.',
      ':',
      '#',
      '(',
    }
  end,

  settings = {
    Lua = {
      runtime = {
        -- stylua: ignore start
        path    = vim.split(package.path, ';'),
        version = 'LuaJIT',
        -- stylua: ignore end
      },

      workspace = {
        ignoreSubmodules = true,

        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
}
