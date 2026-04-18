return {
  "michael-a-grammar/mona.nvim",

  dev = true,

  enabled = false,

  dependencies = {
    "folke/which-key.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },

  keys = {
    {
      "<localleader><localleader>",
      function()
        require("telescope").extensions.mona.pickers()
      end,
      desc = "Pickers",
      ft = "elixir",
      mode = { "n", "x" },
    },

    {
      "<localleader>''",
      function()
        require("mona.integrations.toggleterm").iex({}, function(iex)
          return iex
        end)
      end,
      desc = "iex",
      ft = "elixir",
      mode = { "n", "x" },
    },

    {
      "<localleader>'r",
      function()
        require("mona.integrations.toggleterm").iex({}, function(iex)
          return iex.S("mix")
        end)
      end,
      desc = "iex -S mix",
      ft = "elixir",
      mode = { "n", "x" },
    },

    {
      "<localleader>ni",
      function()
        require("mona.integrations.grug_far").module.imports({
          transient = true,
        })
      end,
      desc = "Find and replace module imports",
      ft = "elixir",
      mode = { "n", "x" },
    },

    {
      "<localleader>nn",
      function()
        require("mona.integrations.grug_far").module.name({
          transient = true,
        })
      end,
      desc = "Find and replace module",
      ft = "elixir",
      mode = { "n", "x" },
    },

    {
      "<localleader>nt",
      function()
        require("mona.elixir.module").edit_test_module()
      end,
      desc = "Edit test module",
      ft = "elixir",
      mode = { "n", "x" },
    },

    {
      "<localleader>nT",
      function()
        require("telescope").extensions.mona.elixir_test_modules()
      end,
      desc = "Test modules",
      ft = "elixir",
      mode = { "n", "x" },
    },

    {
      "<localleader>ta",
      function()
        require("telescope").extensions.mona.elixir_umbrella_app_modules()
      end,
      desc = "Umbrella app modules",
      ft = "elixir",
      mode = { "n", "x" },
    },

    {
      "<localleader>tn",
      function()
        require("telescope").extensions.mona.elixir_buffer_directory_modules()
      end,
      desc = "Buffer directory modules",
      ft = "elixir",
      mode = { "n", "x" },
    },

    {
      "<localleader>tp",
      function()
        require("telescope").extensions.mona.elixir_project_modules()
      end,
      desc = "Project modules",
      ft = "elixir",
      mode = { "n", "x" },
    },

    {
      "<localleader>tta",
      function()
        require("telescope").extensions.mona.elixir_umbrella_app_tests()
      end,
      desc = "Umbrella app tests",
      ft = "elixir",
      mode = { "n", "x" },
    },

    {
      "<localleader>ttn",
      function()
        require("telescope").extensions.mona.elixir_buffer_directory_tests()
      end,
      desc = "Buffer directory tests",
      ft = "elixir",
      mode = { "n", "x" },
    },

    {
      "<localleader>ttp",
      function()
        require("telescope").extensions.mona.elixir_project_tests()
      end,
      desc = "Project tests",
      ft = "elixir",
      mode = { "n", "x" },
    },

    {
      "<leader>zm",
      function()
        vim.print(vim.inspect(require("mona.__debug")()))
      end,
      desc = " ",
      mode = { "n", "x" },
    },
  },

  opts = {
    integrations = {
      bufferline = true,
      grug_far = true,
      toggleterm = true,
    },
  },

  config = function(_, opts)
    -- require("mona").setup(opts)
    --
    -- local icon = require("mona.config").icon("mona")
    --
    -- local to_add = {
    --   {
    --     mode = {
    --       "n",
    --       "x",
    --     },
    --
    --     {
    --       "<localleader>",
    --       group = icon .. " mona",
    --     },
    --
    --     {
    --       "<localleader>'",
    --       group = "",
    --     },
    --
    --     {
    --       "<localleader>n",
    --       "Module",
    --     },
    --
    --     {
    --       "<localleader>t",
    --       "Modules",
    --     },
    --
    --     {
    --       "<localleader>tt",
    --       group = "Tests",
    --     },
    --   },
    -- }
    --
    -- local which_key = require("which-key")
    --
    -- which_key.add(to_add)
  end,
}
