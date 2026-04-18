return {
  "folke/which-key.nvim",

  opts = {
    disable = {
      ft = {
        "lazy",
        "neo-tree",
        "neo-tree-popup",
        "notify",
        "qf",
        "undotree",
        "NeogitCommandHistory",
        "NeogitCommitView",
        "NeogitPopup",
        "NeogitStatus",
        "Outline",
        "TelescopePrompt",
      },
    },

    icons = {
      breadcrumb = " " .. "" .. " ",
      colors = false,
      mappings = false,
    },

    keys = {
      scroll_up = "<c-f>",
      scroll_down = "<c-p>",
    },

    layout = {
      align = "center",
    },

    preset = "modern",

    replace = {
      key = {
        {
          "<bs>",
          "󰁮",
        },

        {
          "<Down>",
          "",
        },

        {
          "<Left>",
          "",
        },

        {
          "<Right>",
          "",
        },

        {
          "<Space>",
          "󱁐",
        },

        {
          "<Tab>",
          "󰌒",
        },

        {
          "<Up>",
          "",
        },
      },
    },

    show_help = false,
  },

  config = function(_, opts)
    local which_key = require("which-key")

    which_key.setup(opts)

    local to_add = {
      {
        mode = {
          "n",
          "x",
        },

        {
          "<leader>a",
          group = "Notifications",
        },

        {
          "<leader>c",
          group = "Slime",
        },

        {
          "<leader>d",
          group = "Diagnostics",
        },

        {
          "<leader>e",
          group = "LSP",
        },

        {
          "<leader>f",
          group = "Navigation",
        },

        {
          "<leader>fq",
          group = "Quickfix",
        },

        {
          "<leader>g",
          group = "Git",
        },

        {
          "<leader>gs",
          group = "Search",
        },

        {
          "<leader>h",
          group = "Harpoon",
        },

        {
          "<leader>k",
          group = "Toggles",
        },

        {
          "<leader>l",
          hidden = true,
        },

        {
          "<leader>m",
          group = "Local",
        },

        {
          "<leader>n",
          group = "Buffer",
        },

        {
          "<leader>na",
          group = "Barbecue",
        },

        {
          "<leader>nc",
          group = "Treesitter context",
        },

        {
          "<leader>nd",
          group = "Close buffer",
        },

        {
          "<leader>nf",
          group = "File",
        },

        {
          "<leader>ng",
          group = "Git",
        },

        {
          "<leader>ngt",
          group = "Toggles",
        },

        {
          "<leader>no",
          group = "Outline",
        },

        {
          "<leader>o",
          group = "Unassigned",
        },

        {
          "<leader>p",
          group = "Edit",
        },

        {
          "<leader>pe",
          group = "Expand or shrink region",
        },

        {
          "<leader>py",
          group = "Yank ring",
        },

        {
          "<leader>q",
          group = "Quit",
        },

        {
          "<leader>r",
          group = "Terminal",
        },

        {
          "<leader>s",
          group = " Find",
        },

        {
          "<leader>st",
          group = " Find",
        },

        {
          "<leader>t",
          group = "Buffers",
        },

        {
          "<leader>td",
          group = "Close other buffers",
        },

        {
          "<leader>tg",
          group = "Buffer groups",
        },

        {
          "<leader>ts",
          group = "Sort buffers",
        },

        {
          "<leader>u",
          group = " Find",
        },

        {
          "<leader>ut",
          group = " Find",
        },

        {
          "<leader>w",
          group = "Windows",
        },

        {
          "<leader>wc",
          group = "New window",
        },

        {
          "<leader>wm",
          group = "Move window",
        },

        {
          "<leader>wn",
          group = "Navigate windows",
        },

        {
          "<leader>wo",
          group = "Rotate window",
        },

        {
          "<leader>wr",
          group = "Resize window",
        },

        {
          "<leader>x",
          group = "Text",
        },

        {
          "<leader>y",
          group = "Tabs",
        },

        {
          "<leader>z",
          group = "Vim",
        },

        {
          "<leader>L",
          hidden = true,
        },
      },
    }

    for index = 2, 9, 1 do
      local terminal_index = tostring(index)

      table.insert(to_add[1], {
        "<leader>r" .. terminal_index,

        group = "Terminal " .. terminal_index,
      })
    end

    which_key.add(to_add)

    vim.keymap.set({ "n", "x" }, "<leader>pe*", function()
      which_key.show({
        keys = "<leader>pe",
        loop = true,
      })
    end, { desc = " " .. " Expand / shrink region", noremap = true })

    vim.keymap.set({ "n", "x" }, "<leader>wc*", function()
      which_key.show({
        keys = "<leader>wc",
        loop = true,
      })
    end, { desc = " " .. " New window", noremap = true })

    vim.keymap.set({ "n", "x" }, "<leader>wm*", function()
      which_key.show({
        keys = "<leader>wm",
        loop = true,
      })
    end, { desc = " " .. " Move window", noremap = true })

    vim.keymap.set({ "n", "x" }, "<leader>wn*", function()
      which_key.show({
        keys = "<leader>wn",
        loop = true,
      })
    end, { desc = " " .. " Navigate window", noremap = true })

    vim.keymap.set({ "n", "x" }, "<leader>wo*", function()
      which_key.show({
        keys = "<leader>wo",
        loop = true,
      })
    end, { desc = " " .. " Rotate window", noremap = true })

    vim.keymap.set({ "n", "x" }, "<leader>wr*", function()
      which_key.show({
        keys = "<leader>wr",
        loop = true,
      })
    end, { desc = " " .. " Resize window", noremap = true })

    local catppuccin =
      require("catppuccin.palettes").get_palette(_G.catppuccin_theme)

    vim.api.nvim_set_hl(0, "WhichKeyIcon", {
      fg = catppuccin.overlay0,
    })
  end,
}
