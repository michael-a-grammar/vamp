return {
  "folke/flash.nvim",

  event = "VeryLazy",

  keys = {
    {
      "r",
      function()
        require("flash").remote()
      end,
      desc = "Flash remote",
      mode = "o",
    },

    {
      "<bs>",
      function()
        require("flash").jump()
      end,
      desc = "Flash",
      mode = {
        "n",
        "x",
        "o",
      },
    },
  },

  opts = {
    labels = "ntesiroamghdkvclpufxzufq",

    prompt = {
      prefix = {
        {
          "󱐌",
          "FlashPromptIcon",
        },
      },
    },
  },
}
