return {
  "MagicDuck/grug-far.nvim",

  config = true,

  keys = {
    {
      "<leader>*",
      function()
        require("vamp.plugins.grug_far.factory").open({
          search_current_word = true,
        })
      end,
      desc = "" .. " Find and replace w/input",
      mode = { "n", "x" },
    },

    {
      "<leader>/",
      function()
        require("vamp.plugins.grug_far.factory").open()
      end,
      desc = "" .. " Find and replace",
      mode = { "n", "x" },
    },

    {
      "<leader>nr",
      function()
        require("vamp.plugins.grug_far.factory").open({
          paths_current_file = true,
        })
      end,
      desc = "Find and replace",
      mode = { "n", "x" },
    },

    {
      "<leader>nR",
      function()
        require("vamp.plugins.grug_far.factory").open({
          paths_current_file = true,
          search_current_word = true,
        })
      end,
      desc = "Find and replace w/input",
      mode = { "n", "x" },
    },

    {
      "<leader>sr",
      function()
        require("vamp.plugins.grug_far.factory").open()
      end,
      desc = "Find and replace",
      mode = { "n", "x" },
    },

    {
      "<leader>sR",
      function()
        require("vamp.plugins.grug_far.factory").open({
          search_current_word = true,
        })
      end,
      desc = "Find and replace w/input",
      mode = { "n", "x" },
    },

    {
      "<leader>str",
      function()
        require("vamp.plugins.grug_far.factory").open({
          files_filter_current_buffer_file_type = true,
        })
      end,
      desc = "Find and replace",
      mode = { "n", "x" },
    },

    {
      "<leader>stR",
      function()
        require("vamp.plugins.grug_far.factory").open({
          files_filter_current_buffer_file_type = true,
          search_current_word = true,
        })
      end,
      desc = "Find and replace w/input",
      mode = { "n", "x" },
    },

    {
      "<leader>ur",
      function()
        require("vamp.plugins.grug_far.factory").open({
          paths_current_file_directory = true,
        })
      end,
      desc = "Find and replace w/input",
      mode = { "n", "x" },
    },

    {
      "<leader>uR",
      function()
        require("vamp.plugins.grug_far.factory").open({
          paths_current_file_directory = true,
          search_current_word = true,
        })
      end,
      desc = "Find and replace w/input",
      mode = { "n", "x" },
    },

    {
      "<leader>utr",
      function()
        require("vamp.plugins.grug_far.factory").open({
          files_filter_current_buffer_file_type = true,
          paths_current_file_directory = true,
        })
      end,
      desc = "Find and replace w/input",
      mode = { "n", "x" },
    },

    {
      "<leader>utR",
      function()
        require("vamp.plugins.grug_far.factory").open({
          files_filter_current_buffer_file_type = true,
          paths_current_file_directory = true,
          search_current_word = true,
        })
      end,
      desc = "Find and replace w/input",
      mode = { "n", "x" },
    },
  },
}
