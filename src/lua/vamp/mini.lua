local new_autocmd = require("vamp.lib.new_autocmd")
local safely = require("vamp.lib.safely")

local now, now_if_args, later = safely.now, safely.now_if_args, safely.later

now(function()
  require("mini.basics").setup({
    autocommands = {
      basic = true,
      relnum_in_visual_mode = false,
    },

    mappings = {
      basic = true,
      option_toggle_prefix = "<leader>k",
      move_with_alt = false,
      windows = false,
    },

    options = {
      basic = false,
      extra_ui = false,
      win_borders = "auto",
    },
  })
end)

now(function()
  local ext3_blocklist = {
    scm = true,
    txt = true,
    yml = true,
  }

  local ext4_blocklist = {
    json = true,
    yaml = true,
  }

  require("mini.icons").setup({
    use_file_extension = function(ext, _)
      return not (ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)])
    end,
  })

  later(MiniIcons.mock_nvim_web_devicons)
  later(MiniIcons.tweak_lsp_kind)
end)

now(function()
  require("mini.notify").setup()

  vim.keymap.set(
    "n",
    "<leader>aa",
    MiniNotify.clear,
    { desc = "Clear notifications", noremap = true }
  )

  vim.keymap.set(
    "n",
    "<leader>ah",
    MiniNotify.show_history,
    { desc = "Notifications history", noremap = true }
  )
end)

now(function()
  require("mini.sessions").setup()

  vim.keymap.set("n", "<leader>sc", function()
    vim.ui.input({ prompt = "Session name: " }, MiniSessions.write)
  end, { desc = "New session", noremap = true })

  vim.keymap.set("n", "<leader>sd", function()
    MiniSessions.select("delete")
  end, { desc = "Delete session", noremap = true })

  vim.keymap.set("n", "<leader>ss", function()
    MiniSessions.select("read")
  end, { desc = "Read session", noremap = true })

  vim.keymap.set(
    "n",
    "<leader>sw",
    MiniSessions.write,
    { desc = "Write session", noremap = true }
  )
end)

now_if_args(function()
  require("mini.files").setup({
    mappings = {
      close = "<esc>",
      go_in = "<cr>",
      go_in_plus = "<c-cr>",
      go_out = "<bs>",
      go_out_plus = "",
      mark_goto = "'",
      mark_set = "m",
      reset = "u",
      reveal_cwd = "@",
      show_help = "g?",
      synchronize = "w",
      trim_left = "<",
      trim_right = ">",
    },

    options = {
      permanent_delete = false,
    },

    windows = {
      preview = false,
    },
  })

  vim.keymap.set("n", "<leader>l", function()
    if not MiniFiles.close() then
      MiniFiles.open()
    end
  end, { desc = "Files", noremap = true })

  vim.keymap.set("n", "<leader>fd", function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
  end, { desc = " Files", noremap = true })

  vim.keymap.set("n", "<leader>ff", function()
    MiniFiles.open(nil, false)
  end, { desc = " Files", noremap = true })

  local show_dotfiles = true

  local filters = {
    hide = function(entry)
      return not vim.startswith(entry.name, ".")
    end,

    show = function()
      return true
    end,
  }

  local toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles

    MiniFiles.refresh({
      content = {
        filter = show_dotfiles and filters.show or filters.hide,
      },
    })
  end

  local split_win_keymap = function(buf_id, lhs, direction, desc)
    local rhs = function()
      local target_window = MiniFiles.get_explorer_state().target_window

      local new_target = vim.api.nvim_win_call(target_window, function()
        vim.cmd(direction .. " split")

        return vim.api.nvim_get_current_win()
      end)

      MiniFiles.go_in()
      MiniFiles.set_target_window(new_target)
    end

    vim.keymap.set("n", lhs, rhs, { desc = desc, buffer = buf_id })
  end

  -- TODO: Yank path, set current working directory, open with default system handler

  new_autocmd("User", "MiniFilesBufferCreate", function(args)
    local buf_id = args.data.buf_id

    vim.keymap.set(
      "n",
      "g.",
      toggle_dotfiles,
      { desc = "Toggle dotfiles", buffer = buf_id }
    )

    split_win_keymap(
      buf_id,
      "<c-s>",
      "belowright horizontal",
      "Split horizontally"
    )
    split_win_keymap(buf_id, "<c-v>", "belowright vertical", "Split vertically")
  end)

  function set_bookmark(id, path, desc)
    MiniFiles.set_bookmark(id, path, { desc = desc })
  end

  new_autocmd("User", "MiniFilesExplorerOpen", function()
    set_bookmark("~", "~/", " ")
    set_bookmark("c", vim.fn.getcwd, " ")
    set_bookmark("d", "~/dev/me/dot-files", " ")
    set_bookmark("p", "~/dev/prima", " ")
    set_bookmark("v", "~/dev/me/vamp", "󰭟 ")
  end, "Add bookmarks to MiniFiles")
end)

now_if_args(function()
  require("mini.misc").setup({
    make_global = {
      "tbl_head",
      "tbl_tail",
    },
  })

  vim.keymap.set(
    "n",
    "<leader>h",
    MiniMisc.zoom,
    { desc = "󰍉 ", noremap = true }
  )

  vim.keymap.set(
    "n",
    "<leader>wr",
    MiniMisc.resize_window,
    { desc = "Resize window to editable width", noremap = true }
  )

  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
end)

later(function()
  require("mini.extra").setup()
end)

later(function()
  local mini_ai = require("mini.ai")

  mini_ai.setup({
    search_method = "cover_or_next",

    custom_textobjects = {
      ["%"] = MiniExtra.gen_ai_spec.buffer(),

      c = mini_ai.gen_spec.function_call(),

      f = mini_ai.gen_spec.treesitter({
        a = "@function.outer",
        i = "@function.inner",
      }),

      o = mini_ai.gen_spec.treesitter({
        a = {
          "@conditional.outer",
          "@loop.outer",
        },

        i = {
          "@conditional.inner",
          "@loop.inner",
        },
      }),
    },
  })
end)

later(function()
  require("mini.align").setup()
end)

later(function()
  require("mini.bracketed").setup({
    buffer = {
      suffix = "",
    },

    window = {
      suffix = "",
    },
  })

  vim.keymap.set("n", "<leader>tn", function()
    MiniBracketed.buffer("forward")
  end, { desc = "Next buffer", noremap = true })

  vim.keymap.set("n", "<leader>tp", function()
    MiniBracketed.buffer("backward")
  end, { desc = "Previous buffer", noremap = true })

  vim.keymap.set("n", "<leader>wf", function()
    MiniBracketed.window("first")
  end, { desc = "First window", noremap = true })

  vim.keymap.set("n", "<leader>wl", function()
    MiniBracketed.window("last")
  end, { desc = "Last window", noremap = true })

  vim.keymap.set("n", "<leader>wn", function()
    MiniBracketed.window("forward")
  end, { desc = "Next window", noremap = true })

  vim.keymap.set("n", "<leader>wp", function()
    MiniBracketed.window("backward")
  end, { desc = "Previous window", noremap = true })
end)

later(function()
  require("mini.bufremove").setup()

  vim.keymap.set(
    "n",
    "<leader>nd",
    MiniBufremove.delete,
    { desc = "Close buffer", noremap = true }
  )

  vim.keymap.set(
    "n",
    "<leader>nw",
    MiniBufremove.wipeout,
    { desc = "Wipeout buffer", noremap = true }
  )

  vim.keymap.set({ "n", "x" }, "<leader>nx", function()
    MiniBufremove.delete(0, true)
  end, { desc = "" .. " Close buffer", noremap = true })
end)

later(function()
  local mini_clue = require("mini.clue")

  mini_clue.setup({
    clues = {
      {
        -- stylua: ignore start
        { mode = "n", keys = "<Leader>a", desc = "+Notifications" },
        { mode = "n", keys = "<Leader>f", desc = "+Navigation"    },
        { mode = "n", keys = "<Leader>g", desc = "+Git"           },
        { mode = "n", keys = "<Leader>k", desc = "+Toggles"       },
        { mode = "n", keys = "<Leader>n", desc = "+Buffer"        },
        { mode = "n", keys = "<Leader>q", desc = "+Quit"          },
        { mode = "n", keys = "<Leader>r", desc = "+Terminal"      },
        { mode = "n", keys = "<Leader>s", desc = "+Session"       },
        { mode = "n", keys = "<Leader>t", desc = "+Terminal"      },
        { mode = "n", keys = "<Leader>y", desc = "+Tabs"          },
        { mode = "n", keys = "<Leader>w", desc = "+Windows"       },
        { mode = "n", keys = "<Leader>z", desc = "+ "            },

        { mode = "n", keys = "<Leader>e", desc = "+Explore/Edit"  },
        { mode = "n", keys = "<Leader>m", desc = "+Map"           },
        { mode = "n", keys = "<Leader>o", desc = "+Other"         },
        { mode = "n", keys = "<Leader>v", desc = "+Visits"        },
        -- stylua: ignore end
      },

      mini_clue.gen_clues.builtin_completion(),
      mini_clue.gen_clues.g(),
      mini_clue.gen_clues.marks(),
      mini_clue.gen_clues.registers(),
      mini_clue.gen_clues.square_brackets(),

      mini_clue.gen_clues.windows({
        submode_move = true,
        submode_navigate = true,
        submode_resize = true,
      }),

      mini_clue.gen_clues.z(),
    },

    triggers = {
      -- stylua: ignore start
      { mode = { "n", "x" }, keys = "<leader>" },
      { mode =   "n",        keys = "\\"       },
      { mode = { "n", "x" }, keys = "["        },
      { mode = { "n", "x" }, keys = "]"        },
      { mode =   "i",        keys = "<c-x>"    },
      { mode = { "n", "x" }, keys = "g"        },
      { mode = { "n", "x" }, keys = "'"        },
      { mode = { "n", "x" }, keys = '`'        },
      { mode = { "n", "x" }, keys = '"'        },
      { mode = { "i", "c" }, keys = "<c-r>"    },
      { mode =   "n",        keys = "<c-w>"    },
      { mode = { "n", "x" }, keys = "s"        },
      { mode = { "n", "x" }, keys = "z"        },
      -- stylua: ignore end
    },

    window = {
      delay = 500,
      scroll_down = "<c-f>",
      scroll_up = "<c-p>",

      config = {
        width = "auto",
      },
    },
  })
end)
