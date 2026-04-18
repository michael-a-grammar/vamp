return {
  "lewis6991/gitsigns.nvim",

  opts = {
    signs = {
      add = {
        text = "",
      },

      change = {
        text = "󰝤",
      },

      changedelete = {
        text = "󰝤",
      },

      delete = {
        text = "",
      },

      topdelete = {
        text = "",
      },

      untracked = {
        text = "󰝤",
      },
    },

    on_attach = function(_)
      local gitsigns = require("gitsigns")

      vim.keymap.set({ "o", "x" }, "ih", ":<c-u>Gitsigns select_hunk<cr>")

      vim.keymap.set(
        { "n", "x" },
        "<leader>nga",
        gitsigns.stage_buffer,
        { desc = "Stage buffer", noremap = true }
      )

      vim.keymap.set(
        { "n", "x" },
        "<leader>ngd",
        gitsigns.diffthis,
        { desc = "Diff", noremap = true }
      )

      vim.keymap.set(
        { "n", "x" },
        "<leader>ngl",
        "<cmd>Gitsigns setloclist<cr>",
        { desc = "Set loclist", noremap = true }
      )

      vim.keymap.set("n", "<leader>ngm", function()
        gitsigns.blame_line({ full = true })
      end, { desc = "Blame", noremap = true })

      vim.keymap.set({ "n", "x" }, "<leader>ngn", function()
        if vim.wo.diff then
          return "]c"
        end

        vim.schedule(function()
          gitsigns.next_hunk()
        end)

        return "<ignore>"
      end, { desc = "Next hunk", expr = true, noremap = true })

      vim.keymap.set({ "n", "x" }, "<leader>ngp", function()
        if vim.wo.diff then
          return "[c"
        end

        vim.schedule(function()
          gitsigns.prev_hunk()
        end)

        return "<ignore>"
      end, { desc = "Previous hunk", expr = true, noremap = true })

      vim.keymap.set(
        { "n", "x" },
        "<leader>ngq",
        "<cmd>Gitsigns setqflist<cr>",
        { desc = "Set quickfix", noremap = true }
      )

      vim.keymap.set(
        "n",
        "<leader>ngr",
        gitsigns.reset_hunk,
        { desc = "Reset hunk", noremap = true }
      )

      vim.keymap.set("x", "<leader>ngr", function()
        gitsigns.reset_hunk({
          vim.fn.line("."),
          vim.fn.line("v"),
        })
      end, { desc = "Reset hunk", noremap = true })

      vim.keymap.set(
        "n",
        "<leader>ngs",
        gitsigns.stage_hunk,
        { desc = "Stage hunk", noremap = true }
      )

      vim.keymap.set("x", "<leader>ngs", function()
        gitsigns.stage_hunk({
          vim.fn.line("."),
          vim.fn.line("v"),
        })
      end, { desc = "Stage hunk", noremap = true })

      vim.keymap.set(
        "n",
        "<leader>ngu",
        gitsigns.undo_stage_hunk,
        { desc = "Undo stage hunk", noremap = true }
      )

      vim.keymap.set(
        { "n", "x" },
        "<leader>ngv",
        gitsigns.preview_hunk,
        { desc = "Preview hunk", noremap = true }
      )

      vim.keymap.set(
        { "n", "x" },
        "<leader>ngx",
        gitsigns.reset_buffer,
        { desc = "Reset buffer", noremap = true }
      )

      vim.keymap.set(
        { "n", "x" },
        "<leader>ngtd",
        gitsigns.toggle_deleted,
        { desc = "Toggle deleted", noremap = true }
      )

      vim.keymap.set(
        { "n", "x" },
        "<leader>ngtl",
        "<cmd>Gitsigns toggle_linehl<cr>",
        { desc = "Toggle line highlight", noremap = true }
      )

      vim.keymap.set(
        { "n", "x" },
        "<leader>ngtm",
        gitsigns.toggle_current_line_blame,
        { desc = "Toggle current line blame", noremap = true }
      )

      vim.keymap.set(
        { "n", "x" },
        "<leader>ngtn",
        "<cmd>Gitsigns toggle_numhl<cr>",
        { desc = "Toggle line numbers highlight", noremap = true }
      )

      vim.keymap.set(
        { "n", "x" },
        "<leader>ngtw",
        "<cmd>Gitsigns toggle_word_diff<cr>",
        { desc = "Toggle word diff", noremap = true }
      )
    end,
  },
}
