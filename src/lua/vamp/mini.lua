-- stylua: ignore start
local new_autocmd = require("vamp.lib.new_autocmd")
local safely      = require("vamp.lib.safely")
-- stylua: ignore end

local now, now_if_args, later = safely.now, safely.now_if_args, safely.later

now(function()
  require("mini.basics").setup({
    autocommands = {
      -- stylua: ignore start
      basic                 = true,
      relnum_in_visual_mode = false,
      -- stylua: ignore end
    },

    mappings = {
      -- stylua: ignore start
      basic                = true,
      option_toggle_prefix = "<leader>k",
      move_with_alt        = false,
      windows              = false,
      -- stylua: ignore end
    },

    options = {
      -- stylua: ignore start
      basic       = false,
      extra_ui    = false,
      win_borders = "auto",
      -- stylua: ignore end
    },
  })

  vim.o.showtabline = 0

  vim.keymap.set("n", "<leader>kt", function()
    if vim.o.showtabline == 0 then
      vim.o.showtabline = 1
    else
      vim.o.showtabline = 0
    end
  end, { desc = "Toggle tabline", noremap = true })
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

  vim.keymap.set("n", "<leader>uc", function()
    vim.ui.input({ prompt = "Session name: " }, MiniSessions.write)
  end, { desc = "New session", noremap = true })

  vim.keymap.set("n", "<leader>ud", function()
    MiniSessions.select("delete")
  end, { desc = "Delete session", noremap = true })

  vim.keymap.set("n", "<leader>uu", function()
    MiniSessions.select("read")
  end, { desc = "Read session", noremap = true })

  vim.keymap.set(
    "n",
    "<leader>uw",
    MiniSessions.write,
    { desc = "Write session", noremap = true }
  )
end)

now_if_args(function()
  require("mini.files").setup({
    mappings = {
      -- stylua: ignore start
      close       = "<esc>",
      go_in       = "<cr>",
      go_in_plus  = "<c-cr>",
      go_out      = "<bs>",
      go_out_plus = "",
      mark_goto   = "'",
      mark_set    = "m",
      reset       = "u",
      reveal_cwd  = "@",
      show_help   = "g?",
      synchronize = "w",
      trim_left   = "<",
      trim_right  = ">",
      -- stylua: ignore start
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
  end, { desc = "Explore", noremap = true })

  vim.keymap.set("n", "<leader>fd", function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
  end, { desc = "Explore from buffer directory", noremap = true })

  vim.keymap.set("n", "<leader>ff", function()
    MiniFiles.open(nil, false)
  end, { desc = "Explore from working directory", noremap = true })

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

  -- TODO: Yank path, set current working directory, open with default system handler, pick from directory

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
    set_bookmark("~", "~/", "Home")
    set_bookmark("c", vim.fn.getcwd, "Working directory")
    set_bookmark("d", "~/dev/me/dot-files", "Dot files")
    set_bookmark("p", "~/dev/prima", "Prima")
    set_bookmark("v", "~/dev/me/vamp", "Vamp")
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
    "<leader>oz",
    MiniMisc.zoom,
    { desc = "Zoom", noremap = true }
  )

  vim.keymap.set(
    "n",
    "<leader>w=",
    MiniMisc.resize_window,
    { desc = "Resize window to editable width", noremap = true }
  )

  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()

  new_autocmd("DirChanged", "*", function(args)
    vim.notify("Directory changed to " .. args.file .. " ")
  end)
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
  require("mini.bracketed").setup()

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
  end, { desc = "Force close buffer", noremap = true })
end)

later(function()
  local mini_clue = require("mini.clue")

  mini_clue.setup({
    clues = {
      {
        -- stylua: ignore start
        { mode = "n", keys = "<leader>a", desc = "+Notifications" },
        { mode = "n", keys = "<leader>f", desc = "+Navigation"    },
        { mode = "n", keys = "<leader>g", desc = "+Git"           },
        { mode = "n", keys = "<leader>k", desc = "+Toggles"       },
        { mode = "n", keys = "<leader>n", desc = "+Buffer"        },
        { mode = "n", keys = "<leader>n", desc = "+Other"         },
        { mode = "n", keys = "<leader>q", desc = "+Quit"          },
        { mode = "n", keys = "<leader>r", desc = "+Terminal"      },
        { mode = "n", keys = "<leader>s", desc = "+Find"          },
        { mode = "n", keys = "<leader>t", desc = "+Buffers"       },
        { mode = "n", keys = "<leader>u", desc = "+Session"       },
        { mode = "n", keys = "<leader>v", desc = "+Vim"           },
        { mode = "n", keys = "<leader>w", desc = "+Windows"       },
        { mode = "n", keys = "<leader>y", desc = "+Tabs"          },

        { mode = "n", keys = "<leader>gh", desc = "+Hunks" },
        { mode = "n", keys = "<leader>nf", desc = "+Path"  },

        { mode = "n", keys = "<leader>ghf", postkeys = "<leader>gh" },
        { mode = "n", keys = "<leader>ghl", postkeys = "<leader>gh" },
        { mode = "n", keys = "<leader>ghn", postkeys = "<leader>gh" },
        { mode = "n", keys = "<leader>ghp", postkeys = "<leader>gh" },
        { mode = "n", keys = "<leader>tn",  postkeys = "<leader>t"  },
        { mode = "n", keys = "<leader>tp",  postkeys = "<leader>t"  },
        { mode = "n", keys = "<leader>wf",  postkeys = "<leader>w"  },
        { mode = "n", keys = "<leader>wl",  postkeys = "<leader>w"  },
        { mode = "n", keys = "<leader>wn",  postkeys = "<leader>w"  },
        { mode = "n", keys = "<leader>wp",  postkeys = "<leader>w"  },
        { mode = "n", keys = "<leader>yf",  postkeys = "<leader>y"  },
        { mode = "n", keys = "<leader>yl",  postkeys = "<leader>y"  },
        { mode = "n", keys = "<leader>yn",  postkeys = "<leader>y"  },
        { mode = "n", keys = "<leader>yp",  postkeys = "<leader>y"  },

        -- { mode = "n", keys = "<Leader>e", desc = "+Explore/Edit"  },
        -- { mode = "n", keys = "<Leader>m", desc = "+Map"           },
        -- { mode = "n", keys = "<Leader>o", desc = "+Other"         },
        -- { mode = "n", keys = "<Leader>v", desc = "+Visits"        },
        -- stylua: ignore end
      },

      mini_clue.gen_clues.builtin_completion(),
      mini_clue.gen_clues.g(),
      mini_clue.gen_clues.marks(),
      mini_clue.gen_clues.registers(),
      mini_clue.gen_clues.square_brackets(),

      mini_clue.gen_clues.windows({
        -- stylua: ignore start
        submode_move     = true,
        submode_navigate = true,
        submode_resize   = true,
        -- stylua: ignore end
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
      -- stylua: ignore start
      delay       = 500,
      scroll_down = "<c-f>",
      scroll_up   = "<c-p>",
      -- stylua: ignore end
    },
  })
end)

later(function()
  require("mini.cmdline").setup({
    autocomplete = {
      delay = 100,
    },

    autocorrect = {
      enable = false,
    },
  })
end)

later(function()
  require("mini.colors").setup()
end)

later(function()
  require("mini.comment").setup()
end)

later(function()
  require("mini.cursorword").setup({
    delay = 1000,
  })

  vim.api.nvim_set_hl(0, "MiniCursorword", {
    bold = true,
  })

  vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", {})
end)

later(function()
  require("mini.diff").setup()

  vim.keymap.set("n", "<leader>gd", function()
    MiniDiff.toggle_overlay()
  end, { desc = "Toggle overlay", noremap = true })

  vim.keymap.set("n", "<leader>gr", function()
    return MiniDiff.operator("reset") .. "_"
  end, { desc = "Reset line", expr = true, remap = true })

  vim.keymap.set("n", "<leader>gs", function()
    return MiniDiff.operator("apply") .. "_"
  end, { desc = "Stage line", expr = true, remap = true })

  vim.keymap.set("n", "<leader>ghf", function()
    MiniDiff.goto_hunk("first")
  end, { desc = "First hunk", noremap = true })

  vim.keymap.set("n", "<leader>ghl", function()
    MiniDiff.goto_hunk("last")
  end, { desc = "Last hunk", noremap = true })

  vim.keymap.set("n", "<leader>ghn", function()
    MiniDiff.goto_hunk("forward")
  end, { desc = "Next hunk", noremap = true })

  vim.keymap.set("n", "<leader>ghp", function()
    MiniDiff.goto_hunk("backward")
  end, { desc = "Previous hunk", noremap = true })

  vim.keymap.set("n", "<leader>ghr", function()
    return MiniDiff.operator("reset") .. "gh"
  end, { desc = "Reset hunk", expr = true, remap = true })

  vim.keymap.set("n", "<leader>ghs", function()
    return MiniDiff.operator("apply") .. "gh"
  end, { desc = "Stage hunk", expr = true, remap = true })

  vim.keymap.set("x", "<leader>ghr", function()
    return "gH"
  end, { desc = "Reset hunk", expr = true, remap = true })

  vim.keymap.set("x", "<leader>ghs", function()
    return "gh"
  end, { desc = "Stage hunk", expr = true, remap = true })
end)

later(function()
  require("mini.git").setup()

  vim.keymap.set(
    "n",
    "<leader>ga",
    "<cmd>Git add %<cr>",
    { desc = "Stage", noremap = true }
  )

  vim.keymap.set(
    "n",
    "<leader>gc",
    "<cmd>Git commit<cr>",
    { desc = "Commit", noremap = true }
  )

  vim.keymap.set("n", "<leader>gf", function()
    MiniGit.show_range_history({
      -- stylua: ignore start
      line_start = 1,
      line_end   = vim.api.nvim_buf_line_count(0),
      -- stylua: ignore end
    })
  end, { desc = "Show history", noremap = true })

  vim.keymap.set(
    { "n", "x" },
    "<leader>gg",
    MiniGit.show_at_cursor,
    { desc = "Show history / diff source", noremap = true }
  )

  vim.keymap.set(
    "n",
    "<leader>gl",
    "<cmd>vertical Git blame -- %<cr>",
    { desc = "Show blame", noremap = true }
  )

  vim.keymap.set(
    "n",
    "<leader>go",
    "<cmd>vertical Git log --oneline<cr>",
    { desc = "Show log", noremap = true }
  )

  new_autocmd("User", "MiniGitCommandSplit", function(args)
    if args.data.git_subcommand ~= "blame" then
      return
    end

    local win_source = args.data.win_source

    vim.wo.wrap = false

    vim.fn.winrestview({
      topline = vim.fn.line("w0", win_source),
    })

    vim.api.nvim_win_set_cursor(0, {
      vim.fn.line(".", win_source),
      0,
    })

    vim.wo[win_source].scrollbind, vim.wo.scrollbind = true, true
  end)
end)

later(function()
  local mini_hipatterns = require("mini.hipatterns")

  local words = MiniExtra.gen_highlighter.words

  mini_hipatterns.setup({
    highlighters = {
      hex_color = mini_hipatterns.gen_highlighter.hex_color(),

      fixme = words({
        "FIXME",
        "Fixme",
        "fixme",
      }, "MiniHipatternsFixme"),

      hack = words({
        "HACK",
        "Hack",
        "hack",
      }, "MiniHipatternsHack"),

      todo = words({
        "TODO",
        "Todo",
        "todo",
      }, "MiniHipatternsTodo"),
    },
  })
end)

later(function()
  require("mini.indentscope").setup()
end)

later(function()
  require("mini.jump").setup({
    delay = {
      highlight = 500,
      idle_stop = 2000000,
    },
  })

  vim.keymap.set({ "n", "x", "o" }, "<esc>", function()
    if not MiniJump.state.jumping then
      return "<esc>"
    end

    MiniJump.stop_jumping()
  end, {
    -- stylua: ignore start
    desc  = "Return to normal mode / cancel jumping",
    expr  = true,
    remap = true,
    -- stylua: ignore start
  })
end)

later(function()
  require("mini.jump2d").setup({
    labels = "ntesiroamghdkvclpufxzufq",

    mappings = {
      start_jumping = "",
    },
  })

  local line_start_opts = MiniJump2d.builtin_opts.line_start

  local start_mini_jump2d = function(cursor_after)
    MiniJump2d.start(vim.tbl_deep_extend("force", line_start_opts, {
      allowed_lines = {
        -- stylua: ignore start
        cursor_before = not cursor_after,
        cursor_at     = false,
        cursor_after  = cursor_after,
        -- stylua: ignore end
      },

      allowed_windows = {
        -- stylua: ignore start
        current     = true,
        not_current = false,
        -- stylua: ignore end
      },
    }))
  end

  vim.keymap.set({ "n", "x" }, "<bs>p", function()
    start_mini_jump2d(false)
  end, { desc = "", noremap = true })

  vim.keymap.set({ "n", "x" }, "<bs>f", function()
    start_mini_jump2d(true)
  end, { desc = "", noremap = true })
end)

later(function()
  require("mini.keymap").setup()
end)

later(function()
  local map = require("mini.map")
  map.setup({
    integrations = {
      map.gen_integration.builtin_search(),
      map.gen_integration.diff(),
      map.gen_integration.diagnostic(),
    },

    symbols = {
      encode = map.gen_encode_symbols.dot("4x2"),
    },
  })

  for _, key in ipairs({ "n", "N", "*", "#" }) do
    local rhs = key
      .. "zv"
      .. "<cmd>lua MiniMap.refresh({}, { lines = false, scrollbar = false })<cr>"

    vim.keymap.set("n", key, rhs)
  end
end)

later(function()
  require("mini.move").setup()
end)

later(function()
  require("mini.operators").setup()
end)
