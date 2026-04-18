return {
  "akinsho/toggleterm.nvim",

  opts = function(_, _)
    local catppuccin =
      require("catppuccin.palettes").get_palette(_G.catppuccin_theme)

    return {
      direction = "float",

      float_opts = {
        border = "rounded",
      },

      highlights = {
        FloatBorder = {
          guifg = catppuccin.blue,
        },
      },

      open_mapping = "<c-t>",

      shade_terminals = false,
    }
  end,

  config = function(_, opts)
    local toggleterm = require("toggleterm")

    toggleterm.setup(opts)

    local set_op_func = vim.fn[vim.api.nvim_exec2(
      [[
        function s:set_op_func(val)
          let &opfunc = a:val
        endfunction
        echon get(function('s:set_op_func'), 'name')
      ]],
      {
        output = true,
      }
    ).output]

    for index = 1, 9, 1 do
      local terminal_index = tostring(index)
      local keymap_index = index == 1 and "" or terminal_index

      vim.keymap.set("n", "<leader>r" .. keymap_index .. "%", function()
        set_op_func(function(motion_type)
          toggleterm.send_lines_to_terminal(
            motion_type,
            true,
            { args = terminal_index }
          )
        end)

        vim.api.nvim_feedkeys("ggg@G''", "n", false)
      end, { desc = "Send buffer to terminal", noremap = true })

      vim.keymap.set(
        { "n", "x" },
        "<leader>r" .. keymap_index .. "e",
        ":" .. terminal_index .. 'TermExec cmd="',
        { desc = "Terminal exec", noremap = true }
      )

      vim.keymap.set(
        { "n", "x" },
        "<leader>r" .. keymap_index .. "f",
        "<cmd>" .. terminal_index .. "ToggleTerm direction=float<cr>",
        { desc = "Toggle terminal float", noremap = true }
      )

      vim.keymap.set(
        { "n", "x" },
        "<leader>r" .. keymap_index .. "h",
        "<cmd>" .. terminal_index .. "ToggleTerm direction=horizontal<cr>",
        { desc = "Toggle terminal horizontal", noremap = true }
      )

      vim.keymap.set("n", "<leader>r" .. keymap_index .. "l", function()
        toggleterm.send_lines_to_terminal(
          "single_line",
          true,
          { args = terminal_index }
        )
      end, { desc = "Send line to terminal", noremap = true })

      vim.keymap.set("x", "<leader>r" .. keymap_index .. "l", function()
        toggleterm.send_lines_to_terminal(
          "visual_lines",
          true,
          { args = terminal_index }
        )
      end, { desc = "Send lines to terminal", noremap = true })

      vim.keymap.set("n", "<leader>r" .. keymap_index .. "o", function()
        set_op_func(function(motion_type)
          toggleterm.send_lines_to_terminal(
            motion_type,
            true,
            { args = terminal_index }
          )
        end)

        vim.api.nvim_feedkeys("g@", "n", false)
      end, { desc = "Send motion to terminal", noremap = true })

      vim.keymap.set("x", "<leader>r" .. keymap_index .. "s", function()
        toggleterm.send_lines_to_terminal(
          "visual_selection",
          true,
          { args = terminal_index }
        )
      end, { desc = "Send selection to terminal", noremap = true })

      vim.keymap.set(
        { "n", "x" },
        "<leader>r" .. keymap_index .. "v",
        "<cmd>" .. terminal_index .. "ToggleTerm size=90 direction=vertical<cr>",
        { desc = "Toggle terminal vertical", noremap = true }
      )
    end

    vim.keymap.set(
      { "n", "x" },
      "<leader>rr",
      "<cmd>TermSelect<cr>",
      { desc = "Select terminal", noremap = true }
    )

    vim.keymap.set(
      { "n", "x" },
      "<leader>rt",
      "<cmd>ToggleTermToggleAll<cr>",
      { desc = "Toggle all terminals", noremap = true }
    )
  end,
}
