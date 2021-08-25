return {
  on_attach = function(client, _)
    client.server_capabilities.completionProvider.triggerCharacters = {
      '.',
      ':',
      '#',
      '(',
    }
  end,

  settings = {
    Lua = {
      diagnostics = {
        globals = require('vamp.lib.cartographer').diagnostic_whitelist(),
      },

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
