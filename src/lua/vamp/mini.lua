-- stylua: ignore start
local new_autocmd = require('vamp.lib.new_autocmd')
local safely      = require('vamp.lib.safely')
-- stylua: ignore end

local now, now_if_args, later = safely.now, safely.now_if_args, safely.later

now(function()
  require('mini.basics').setup({
    autocommands = {
      -- stylua: ignore start
      basic                 = true,
      relnum_in_visual_mode = false,
      -- stylua: ignore end
    },

    mappings = {
      -- stylua: ignore start
      basic                = true,
      option_toggle_prefix = '<Leader>k',
      move_with_alt        = false,
      windows              = false,
      -- stylua: ignore end
    },

    options = {
      -- stylua: ignore start
      basic       = false,
      extra_ui    = false,
      win_borders = 'auto',
      -- stylua: ignore end
    },
  })

  local keymap = vim.tbl_filter(function(keymap)
    return keymap.lhs == vim.g.mapleader .. 'kC'
  end, vim.api.nvim_get_keymap('n'))[1]

  vim.keymap.set(
    'n',
    '<Leader>ko',
    keymap.rhs,
    { desc = keymap.desc, noremap = keymap.noremap == 1 }
  )

  vim.keymap.del('n', '<Leader>kC')
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

  require('mini.icons').setup({
    use_file_extension = function(ext, _)
      return not (ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)])
    end,
  })

  later(MiniIcons.mock_nvim_web_devicons)
  later(MiniIcons.tweak_lsp_kind)
end)

now(function()
  require('mini.notify').setup({
    window = {
      config = function()
        local has_statusline = vim.o.laststatus > 0

        local padding = vim.o.cmdheight + (has_statusline and 1 or 0)

        return {
          -- stylua: ignore start
          anchor = 'SE',
          col    = vim.o.columns,
          row    = vim.o.lines - padding,
          -- stylua: ignore end
        }
      end,
    },
  })

  vim.keymap.set(
    'n',
    '<Leader>a',
    MiniNotify.clear,
    { desc = 'Clear notifications', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>hn',
    MiniNotify.show_history,
    { desc = 'Notifications', noremap = true }
  )
end)

now(function()
  require('mini.sessions').setup()

  vim.keymap.set('n', '<Leader>uc', function()
    vim.ui.input({ prompt = 'Session name: ' }, MiniSessions.write)
  end, { desc = 'New session', noremap = true })

  vim.keymap.set('n', '<Leader>ud', function()
    MiniSessions.select('delete')
  end, { desc = 'Delete session', noremap = true })

  vim.keymap.set('n', '<Leader>uu', function()
    MiniSessions.select('read')
  end, { desc = 'Read session', noremap = true })

  vim.keymap.set(
    'n',
    '<Leader>uw',
    MiniSessions.write,
    { desc = 'Write session', noremap = true }
  )
end)

now_if_args(function()
  require('mini.files').setup({
    mappings = {
      -- stylua: ignore start
      close       = 'q',
      go_in       = '<CR>',
      go_in_plus  = '<C-CR>',
      go_out      = '<BS>',
      go_out_plus = '',
      mark_goto   = "'",
      mark_set    = 'm',
      reset       = 'gu',
      reveal_cwd  = '@',
      show_help   = 'g?',
      synchronize = 'gw',
      trim_left   = '<',
      trim_right  = '>',
      -- stylua: ignore end
    },

    options = {
      permanent_delete = false,
    },

    windows = {
      -- stylua: ignore start
      preview       = false,
      width_preview = 50,
      -- stylua: ignore end
    },
  })

  local function mini_files_toggle(mini_files_open)
    if not MiniFiles.close() then
      mini_files_open()
    end
  end

  vim.keymap.set('n', '<Leader>fd', function()
    mini_files_toggle(function()
      MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
    end)
  end, { desc = 'Files (buffer directory)', noremap = true })

  vim.keymap.set('n', '<Leader>ff', function()
    mini_files_toggle(function()
      MiniFiles.open(nil, false)
    end)
  end, { desc = 'Files (working directory)', noremap = true })

  vim.keymap.set('n', '<Leader>l', function()
    mini_files_toggle(MiniFiles.open)
  end, { desc = 'Files', noremap = true })

  local show_dotfiles, show_preview = true, true

  local filters = {
    hide = function(entry)
      return not vim.startswith(entry.name, '.')
    end,

    show = function()
      return true
    end,
  }

  local function toggle_dotfiles()
    show_dotfiles = not show_dotfiles

    MiniFiles.refresh({
      content = {
        filter = show_dotfiles and filters.show or filters.hide,
      },
    })
  end

  local function toggle_preview()
    show_preview = not show_preview

    MiniFiles.refresh({
      windows = {
        preview = show_preview,
      },
    })
  end

  local function split_win_keymap(buf_id, lhs, direction, desc)
    local function rhs()
      local target_window = MiniFiles.get_explorer_state().target_window

      local new_target = vim.api.nvim_win_call(target_window, function()
        vim.cmd(direction .. ' split')

        return vim.api.nvim_get_current_win()
      end)

      MiniFiles.go_in()
      MiniFiles.set_target_window(new_target)
    end

    vim.keymap.set('n', lhs, rhs, { desc = desc, buffer = buf_id })
  end

  new_autocmd('User', 'MiniFilesBufferCreate', function(args)
    local buf_id = args.data.buf_id

    vim.keymap.set(
      'n',
      'g.',
      toggle_dotfiles,
      { desc = 'Toggle dotfiles', buffer = buf_id }
    )

    vim.keymap.set(
      'n',
      'gp',
      toggle_preview,
      { desc = 'Toggle preview', buffer = buf_id }
    )

    split_win_keymap(
      buf_id,
      '<C-s>',
      'belowright horizontal',
      'Split horizontally'
    )

    split_win_keymap(buf_id, '<C-v>', 'belowright vertical', 'Split vertically')
  end)

  function set_bookmark(id, path, desc)
    if (vim.uv or vim.loop).fs_stat(vim.fn.expand(path)) then
      MiniFiles.set_bookmark(id, path, { desc = desc })
    end
  end

  new_autocmd('User', 'MiniFilesExplorerOpen', function()
    set_bookmark('~', '~/', 'Home')
    set_bookmark('c', vim.fn.getcwd(), 'Working directory')
    set_bookmark('d', '~/dev/me/dot-files', 'Dot files')
    set_bookmark('p', '~/dev/prima', 'Prima')
    set_bookmark('v', '~/dev/me/vamp', 'Vamp')
  end, 'Add bookmarks to MiniFiles')
end)

now_if_args(function()
  require('mini.misc').setup({
    make_global = {
      'put',
      'put_text',
      'tbl_head',
      'tbl_tail',
    },
  })

  vim.keymap.set(
    'n',
    '<Leader>wr',
    MiniMisc.resize_window,
    { desc = 'Resize window to editable width', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>z',
    MiniMisc.zoom,
    { desc = 'Zoom', noremap = true }
  )

  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()
  MiniMisc.setup_termbg_sync()
end)

later(function()
  require('mini.extra').setup()

  vim.keymap.set('n', '<Leader>.', function()
    MiniExtra.pickers.explorer({
      cwd = vim.fn.expand('%:h'),
    })
  end, { desc = 'Explorer (buffer directory)', noremap = true })

  vim.keymap.set(
    'n',
    '<Leader>>',
    MiniExtra.pickers.explorer,
    { desc = 'Explorer (working directory)', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>@c',
    MiniExtra.pickers.git_commits,
    { desc = 'Commits', noremap = true }
  )

  vim.keymap.set('n', '<Leader>@hh', function()
    MiniExtra.pickers.git_hunks({
      scope = 'unstaged',
    })
  end, { desc = 'Unstaged hunks', noremap = true })

  vim.keymap.set('n', '<Leader>@hu', function()
    MiniExtra.pickers.git_hunks({
      scope = 'staged',
    })
  end, { desc = 'Staged hunks', noremap = true })

  vim.keymap.set('n', '<Leader>fc', function()
    MiniExtra.pickers.list({
      scope = 'change',
    })
  end, { desc = 'Change list', noremap = true })

  vim.keymap.set('n', '<Leader>fl', function()
    MiniExtra.pickers.list({
      scope = 'location',
    })
  end, { desc = 'Location list', noremap = true })

  vim.keymap.set(
    'n',
    '<Leader>fm',
    MiniExtra.pickers.marks,
    { desc = 'Marks', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>fo',
    MiniExtra.pickers.oldfiles,
    { desc = 'Old files (global)', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>fp',
    MiniExtra.pickers.hipatterns,
    { desc = 'Highlight patterns', noremap = true }
  )

  vim.keymap.set('n', '<Leader>fq', function()
    MiniExtra.pickers.list({
      scope = 'quickfix',
    })
  end, { desc = 'Quickfix list', noremap = true })

  vim.keymap.set('n', '<Leader>fr', function()
    MiniExtra.pickers.oldfiles({
      current_dir = true,
    })
  end, { desc = 'Old files (working directory)', noremap = true })

  vim.keymap.set('n', '<Leader>fu', function()
    MiniExtra.pickers.list({
      scope = 'jump',
    })
  end, { desc = 'Jump list', noremap = true })

  vim.keymap.set(
    'n',
    '<Leader>fv',
    MiniExtra.pickers.visit_paths,
    { desc = 'Visits', noremap = true }
  )

  vim.keymap.set('n', '<Leader>gc', function()
    MiniExtra.pickers.git_commits({
      path = vim.fn.expand('%'),
    })
  end, { desc = 'Commits', noremap = true })

  vim.keymap.set('n', '<Leader>ghh', function()
    MiniExtra.pickers.git_hunks({
      -- stylua: ignore start
      path  = vim.fn.expand("%"),
      scope = 'unstaged',
      -- stylua: ignore end
    })
  end, { desc = 'Unstaged hunks', noremap = true })

  vim.keymap.set('n', '<Leader>ghu', function()
    MiniExtra.pickers.git_hunks({
      -- stylua: ignore start
      path  = vim.fn.expand("%"),
      scope = 'staged',
      -- stylua: ignore end
    })
  end, { desc = 'Staged hunks', noremap = true })

  vim.keymap.set('n', '<Leader>h/', function()
    MiniExtra.pickers.history({
      scope = '/',
    })
  end, { desc = 'Searches', noremap = true })

  vim.keymap.set('n', '<Leader>h:', function()
    MiniExtra.pickers.history({
      scope = ':',
    })
  end, { desc = 'Commands', noremap = true })

  vim.keymap.set('n', '<Leader>nm', function()
    MiniExtra.pickers.marks({
      scope = 'buf',
    })
  end, { desc = 'Marks', noremap = true })

  vim.keymap.set('n', '<Leader>np', function()
    MiniExtra.pickers.hipatterns({
      scope = 'current',
    })
  end, { desc = 'Highlight patterns', noremap = true })

  vim.keymap.set(
    'n',
    '<Leader>ns',
    MiniExtra.pickers.spellsuggest,
    { desc = 'Spelling suggestions', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>ss',
    MiniExtra.pickers.visit_labels,
    { desc = 'Labels', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>v"',
    MiniExtra.pickers.registers,
    { desc = 'Registers', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>v:',
    MiniExtra.pickers.commands,
    { desc = 'Commands', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>vc',
    MiniExtra.pickers.colorschemes,
    { desc = 'Colour schemes', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>vh',
    MiniExtra.pickers.hl_groups,
    { desc = 'Highlight groups', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>vk',
    MiniExtra.pickers.keymaps,
    { desc = 'Keymaps', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>vm',
    MiniExtra.pickers.manpages,
    { desc = 'Manpages', noremap = true }
  )

  vim.keymap.set('n', '<Leader>vo', function()
    MiniExtra.pickers.options({
      scope = 'all',
    })
  end, { desc = 'Options', noremap = true })
end)

later(function()
  local mini_ai = require('mini.ai')

  mini_ai.setup({
    mappings = {
      around_last = 'ap',
      inside_last = 'ip',
    },

    custom_textobjects = {
      ['#'] = MiniExtra.gen_ai_spec.number(),

      ['%'] = MiniExtra.gen_ai_spec.buffer(),

      ['.'] = MiniExtra.gen_ai_spec.line(),

      a = mini_ai.gen_spec.argument(),

      c = mini_ai.gen_spec.function_call(),

      d = MiniExtra.gen_ai_spec.diagnostic(),

      f = mini_ai.gen_spec.treesitter({
        a = '@function.outer',
        i = '@function.inner',
      }),

      i = MiniExtra.gen_ai_spec.indent(),

      k = mini_ai.gen_spec.treesitter({
        a = '@block.outer',
        i = '@block.inner',
      }),

      o = mini_ai.gen_spec.treesitter({
        a = {
          '@conditional.outer',
          '@loop.outer',
        },

        i = {
          '@conditional.inner',
          '@loop.inner',
        },
      }),
    },
  })
end)

later(function()
  require('mini.align').setup()
end)

later(function()
  require('mini.bracketed').setup()

  vim.keymap.set('n', '<Leader>tn', function()
    MiniBracketed.buffer('forward')
  end, { desc = 'Next buffer', noremap = true })

  vim.keymap.set('n', '<Leader>tp', function()
    MiniBracketed.buffer('backward')
  end, { desc = 'Previous buffer', noremap = true })

  vim.keymap.set('n', '<Leader>wf', function()
    MiniBracketed.window('first')
  end, { desc = 'First window', noremap = true })

  vim.keymap.set('n', '<Leader>wl', function()
    MiniBracketed.window('last')
  end, { desc = 'Last window', noremap = true })

  vim.keymap.set('n', '<Leader>wn', function()
    MiniBracketed.window('forward')
  end, { desc = 'Next window', noremap = true })

  vim.keymap.set('n', '<Leader>wp', function()
    MiniBracketed.window('backward')
  end, { desc = 'Previous window', noremap = true })
end)

later(function()
  require('mini.bufremove').setup()

  vim.keymap.set(
    'n',
    '<Leader>nd',
    MiniBufremove.delete,
    { desc = 'Close buffer', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>nw',
    MiniBufremove.wipeout,
    { desc = 'Wipeout buffer', noremap = true }
  )

  vim.keymap.set('n', '<Leader>nx', function()
    MiniBufremove.delete(0, true)
  end, { desc = 'Force close buffer', noremap = true })

  vim.keymap.set('n', '<Leader>td', function()
    for _, bufinfo in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
      local bufnr = bufinfo.bufnr

      if vim.bo[bufnr].buftype ~= '' then
        MiniBufremove.delete(bufnr)
      end
    end
  end, {
    desc = 'Close all buffers',
    noremap = true,
  })
end)

later(function()
  local mini_clue = require('mini.clue')

  mini_clue.setup({
    clues = {
      {
        -- stylua: ignore start
        { mode = 'n', keys = '<Leader>@', desc = '+Git (working directory)' },

        { mode = 'n', keys = '<Leader>@a', desc = '+Actions' },
        { mode = 'n', keys = '<Leader>@d', desc = '+Diff'    },
        { mode = 'n', keys = '<Leader>@h', desc = '+Hunks'   },

        { mode = { 'n', 'x' }, keys = '<Leader>c', desc = '+Context'      },
        { mode = 'n',          keys = '<Leader>f', desc = '+Navigation'   },
        { mode = { 'n', 'x' }, keys = '<Leader>g', desc = '+Git (buffer)' },
        { mode = 'n',          keys = '<Leader>h', desc = '+History'      },
        { mode = 'n',          keys = '<Leader>i', desc = '+Map'          },
        { mode = 'n',          keys = '<Leader>k', desc = '+Toggles'      },
        { mode = 'n',          keys = '<Leader>n', desc = '+Buffer'       },
        { mode = 'n',          keys = '<Leader>q', desc = '+Quit'         },
        { mode = 'n',          keys = '<Leader>r', desc = '+Terminal'     },
        { mode = 'n',          keys = '<Leader>s', desc = '+Visits'       },
        { mode = 'n',          keys = '<Leader>t', desc = '+Buffers'      },
        { mode = 'n',          keys = '<Leader>u', desc = '+Session'      },
        { mode = 'n',          keys = '<Leader>v', desc = '+Vim'          },
        { mode = 'n',          keys = '<Leader>w', desc = '+Windows'      },
        { mode = { 'n', 'x' }, keys = '<Leader>x', desc = '+Text'         },
        { mode = 'n',          keys = '<Leader>y', desc = '+Tabs'         },

        { mode = 'n',          keys = '<Leader>ga', desc = '+Actions' },
        { mode = 'n',          keys = '<Leader>gd', desc = '+Diff'    },
        { mode = { 'n', 'x' }, keys = '<Leader>gh', desc = '+Hunks'   },
        { mode = 'n',          keys = '<Leader>nf', desc = '+Path'    },

        { mode = 'n',          keys = '<Leader>ghf', postkeys = '<Leader>gh' },
        { mode = 'n',          keys = '<Leader>ghl', postkeys = '<Leader>gh' },
        { mode = 'n',          keys = '<Leader>ghn', postkeys = '<Leader>gh' },
        { mode = 'n',          keys = '<Leader>ghp', postkeys = '<Leader>gh' },
        { mode = 'n',          keys = '<Leader>kb',  postkeys = '<Leader>k'  },
        { mode = 'n',          keys = '<Leader>kc',  postkeys = '<Leader>k'  },
        { mode = 'n',          keys = '<Leader>kd',  postkeys = '<Leader>k'  },
        { mode = 'n',          keys = '<Leader>ke',  postkeys = '<Leader>k'  },
        { mode = 'n',          keys = '<Leader>kh',  postkeys = '<Leader>k'  },
        { mode = 'n',          keys = '<Leader>ki',  postkeys = '<Leader>k'  },
        { mode = 'n',          keys = '<Leader>kl',  postkeys = '<Leader>k'  },
        { mode = 'n',          keys = '<Leader>kn',  postkeys = '<Leader>k'  },
        { mode = 'n',          keys = '<Leader>ko',  postkeys = '<Leader>k'  },
        { mode = 'n',          keys = '<Leader>kr',  postkeys = '<Leader>k'  },
        { mode = 'n',          keys = '<Leader>ks',  postkeys = '<Leader>k'  },
        { mode = 'n',          keys = '<Leader>kt',  postkeys = '<Leader>k'  },
        { mode = 'n',          keys = '<Leader>kw',  postkeys = '<Leader>k'  },
        { mode = 'n',          keys = '<Leader>tn',  postkeys = '<Leader>t'  },
        { mode = 'n',          keys = '<Leader>tp',  postkeys = '<Leader>t'  },
        { mode = 'n',          keys = '<Leader>wf',  postkeys = '<Leader>w'  },
        { mode = 'n',          keys = '<Leader>wl',  postkeys = '<Leader>w'  },
        { mode = 'n',          keys = '<Leader>wn',  postkeys = '<Leader>w'  },
        { mode = 'n',          keys = '<Leader>wp',  postkeys = '<Leader>w'  },
        { mode = 'n',          keys = '<Leader>ws',  postkeys = '<Leader>w'  },
        { mode = 'n',          keys = '<Leader>wv',  postkeys = '<Leader>w'  },
        { mode = { 'n', 'x' }, keys = '<Leader>xi',  postkeys = '<Leader>x'  },
        { mode = 'n',          keys = '<Leader>yf',  postkeys = '<Leader>y'  },
        { mode = 'n',          keys = '<Leader>yl',  postkeys = '<Leader>y'  },
        { mode = 'n',          keys = '<Leader>yn',  postkeys = '<Leader>y'  },
        { mode = 'n',          keys = '<Leader>yp',  postkeys = '<Leader>y'  },
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
      { mode = { 'n', 'x' }, keys = '<Leader>' },
      { mode = { 'n', 'x' }, keys = '<BS>'     },
      { mode =   'n',        keys = '\\'       },
      { mode = { 'n', 'x' }, keys = '['        },
      { mode = { 'n', 'x' }, keys = ']'        },
      { mode =   'i',        keys = '<C-x>'    },
      { mode = { 'n', 'x' }, keys = 'g'        },
      { mode = { 'n', 'x' }, keys = '"'        },
      { mode = { 'n', 'x' }, keys = '`'        },
      { mode = { 'n', 'x' }, keys = "'"        },
      { mode = { 'i', 'c' }, keys = '<C-r>'    },
      { mode =   'n',        keys = '<C-w>'    },
      { mode = { 'n', 'x' }, keys = 's'        },
      { mode = { 'n', 'x' }, keys = 'z'        },
      -- stylua: ignore end
    },

    window = {
      -- stylua: ignore start
      delay       = 500,
      scroll_down = '<C-f>',
      scroll_up   = '<C-p>',
      -- stylua: ignore end

      config = function()
        return {
          -- stylua: ignore start
          anchor = 'SE',
          col    = 'auto',
          row    = 'auto',
          width  = 'auto',
          -- stylua: ignore end
        }
      end,
    },
  })
end)

later(function()
  require('mini.cmdline').setup({
    autocomplete = {
      delay = 100,
    },

    autocorrect = {
      enable = false,
    },
  })
end)

later(function()
  require('mini.colors').setup()
end)

later(function()
  require('mini.comment').setup()
end)

later(function()
  require('mini.cursorword').setup({
    delay = 1000,
  })

  vim.api.nvim_set_hl(0, 'MiniCursorword', {
    bold = true,
  })

  vim.api.nvim_set_hl(0, 'MiniCursorwordCurrent', {})
end)

later(function()
  require('mini.diff').setup()

  vim.keymap.set('n', '<Leader>gar', function()
    return MiniDiff.operator('reset') .. '_'
  end, { desc = 'Reset line', expr = true, remap = true })

  vim.keymap.set('n', '<Leader>gas', function()
    return MiniDiff.operator('apply') .. '_'
  end, { desc = 'Stage line', expr = true, remap = true })

  vim.keymap.set(
    'n',
    '<Leader>gg',
    MiniDiff.toggle_overlay,
    { desc = 'Toggle overlay', noremap = true }
  )

  vim.keymap.set('n', '<Leader>ghf', function()
    MiniDiff.goto_hunk('first')
  end, { desc = 'First hunk', noremap = true })

  vim.keymap.set('n', '<Leader>ghl', function()
    MiniDiff.goto_hunk('last')
  end, { desc = 'Last hunk', noremap = true })

  vim.keymap.set('n', '<Leader>ghn', function()
    MiniDiff.goto_hunk('next')
  end, { desc = 'Next hunk', noremap = true })

  vim.keymap.set('n', '<Leader>ghp', function()
    MiniDiff.goto_hunk('prev')
  end, { desc = 'Previous hunk', noremap = true })

  vim.keymap.set('n', '<Leader>ghr', function()
    return MiniDiff.operator('reset') .. 'gh'
  end, { desc = 'Reset hunk', expr = true, remap = true })

  vim.keymap.set('n', '<Leader>ghs', function()
    return MiniDiff.operator('apply') .. 'gh'
  end, { desc = 'Stage hunk', expr = true, remap = true })

  vim.keymap.set('x', '<Leader>ghr', function()
    return 'gH'
  end, { desc = 'Reset hunk', expr = true, remap = true })

  vim.keymap.set('x', '<Leader>ghs', function()
    return 'gh'
  end, { desc = 'Stage hunk', expr = true, remap = true })
end)

later(function()
  require('mini.git').setup()

  -- stylua: ignore start
  local git_log_cmd        = [[<Cmd>vertical Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
  local git_log_buffer_cmd = git_log_cmd .. ' --follow -- %<CR>'
  -- stylua: ignore end

  git_log_cmd = git_log_cmd .. '<CR>'

  vim.keymap.set(
    'n',
    '<Leader>@aa',
    '<Cmd>Git add .<CR>',
    { desc = 'Stage all', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>@ac',
    '<Cmd>Git commit<CR>',
    { desc = 'Commit all', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>@am',
    '<Cmd>Git commit --amend<CR>',
    { desc = 'Commit all (amend)', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>@dd',
    '<Cmd>Git diff<CR>',
    { desc = 'Diff (unstaged)', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>@ds',
    '<Cmd>Git diff --cached<CR>',
    { desc = 'Diff (staged)', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>@l',
    git_log_cmd,
    { desc = 'Show log', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>gaa',
    '<Cmd>Git add %<CR>',
    { desc = 'Stage', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>gac',
    '<Cmd>Git commit %<CR>',
    { desc = 'Commit', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>gam',
    '<Cmd>Git commit % --amend<CR>',
    { desc = 'Commit (amend)', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>gdd',
    '<Cmd>Git diff -- %<CR>',
    { desc = 'Diff (unstaged)', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>gds',
    '<Cmd>Git diff --cached -- %<CR>',
    { desc = 'Diff (staged)', noremap = true }
  )

  vim.keymap.set('n', '<Leader>gf', function()
    MiniGit.show_range_history({
      -- stylua: ignore start
      line_start = 1,
      line_end   = vim.api.nvim_buf_line_count(0),
      -- stylua: ignore end
    })
  end, { desc = 'Show history', noremap = true })

  vim.keymap.set(
    'n',
    '<Leader>gk',
    MiniGit.show_at_cursor,
    { desc = 'Show line history / diff source', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>gl',
    git_log_buffer_cmd,
    { desc = 'Show log', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>gm',
    '<Cmd>vertical Git blame -- %<CR>',
    { desc = 'Show blame', noremap = true }
  )

  vim.keymap.set(
    'x',
    '<Leader>gk',
    MiniGit.show_at_cursor,
    { desc = 'Show range history / diff source', noremap = true }
  )

  new_autocmd('User', 'MiniGitCommandSplit', function(args)
    if args.data.git_subcommand ~= 'blame' then
      return
    end

    local win_source = args.data.win_source

    vim.wo.wrap = false

    vim.fn.winrestview({
      topline = vim.fn.line('w0', win_source),
    })

    vim.api.nvim_win_set_cursor(0, {
      vim.fn.line('.', win_source),
      0,
    })

    vim.wo[win_source].scrollbind, vim.wo.scrollbind = true, true
  end)
end)

later(function()
  local mini_hipatterns = require('mini.hipatterns')

  local words = MiniExtra.gen_highlighter.words

  mini_hipatterns.setup({
    highlighters = {
      hex_color = mini_hipatterns.gen_highlighter.hex_color(),

      fixme = words({
        'FIXME',
        'Fixme',
        'fixme',
      }, 'MiniHipatternsFixme'),

      hack = words({
        'HACK',
        'Hack',
        'hack',
      }, 'MiniHipatternsHack'),

      todo = words({
        'TODO',
        'Todo',
        'todo',
      }, 'MiniHipatternsTodo'),
    },
  })
end)

later(function()
  require('mini.indentscope').setup()

  vim.keymap.set(
    'n',
    '<Leader>xi',
    function()
      return 'Vai'
    end,
    { desc = 'Visually select around indent scope', expr = true, remap = true }
  )

  vim.keymap.set('x', '<Leader>xi', function()
    return 'ai'
  end, { desc = 'Select around indent scope', expr = true, remap = true })
end)

later(function()
  require('mini.input').setup()
end)

later(function()
  require('mini.jump').setup({
    delay = {
      highlight = 500,
      idle_stop = 2000000,
    },
  })

  vim.keymap.set({ 'n', 'x', 'o' }, '<Esc>', function()
    if not MiniJump.state.jumping then
      return '<Esc>'
    end

    MiniJump.stop_jumping()
  end, { expr = true, remap = true })
end)

later(function()
  require('mini.jump2d').setup({
    labels = 'ntesiroamghdkvclpufxzufq',

    mappings = {
      start_jumping = '',
    },

    view = {
      dim = true,
    },
  })

  local start_opts = MiniJump2d.builtin_opts.word_start

  local function start_mini_jump2d(current)
    MiniJump2d.start(vim.tbl_deep_extend('force', start_opts, {
      allowed_lines = {
        -- stylua: ignore start
        cursor_before = true,
        cursor_at     = false,
        cursor_after  = true,
        -- stylua: ignore end
      },

      allowed_windows = {
        -- stylua: ignore start
        current     = current,
        not_current = not current,
        -- stylua: ignore end
      },
    }))
  end

  vim.keymap.set({ 'n', 'x' }, '<BS><Space>', function()
    start_mini_jump2d(true)
  end, { desc = 'Jump (current window)', noremap = true })

  vim.keymap.set({ 'n', 'x' }, '<BS>w', function()
    start_mini_jump2d(false)
  end, { desc = 'Jump (other windows)', noremap = true })
end)

later(function()
  local keymap = require('mini.keymap')

  keymap.map_combo('n', '<Esc><Esc>', function()
    vim.cmd('nohlsearch')
  end)

  keymap.map_combo('i', 'kk', '<BS><BS><Esc>[s1z=gi<Right>')
end)

later(function()
  local mini_map = require('mini.map')

  mini_map.setup({
    integrations = {
      mini_map.gen_integration.builtin_search(),
      mini_map.gen_integration.diff(),
      mini_map.gen_integration.diagnostic(),
    },

    symbols = {
      encode = mini_map.gen_encode_symbols.dot('4x2'),
    },
  })

  vim.keymap.set(
    'n',
    '<Leader>if',
    MiniMap.toggle_focus,
    { desc = 'Focus', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>ii',
    MiniMap.toggle,
    { desc = 'Toggle', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>ir',
    MiniMap.refresh,
    { desc = 'Refresh', noremap = true }
  )

  for _, key in ipairs({ 'n', 'N', '*', '#' }) do
    local rhs = key
      .. 'zz'
      .. 'zv'
      .. '<Cmd>lua MiniMap.refresh({}, { lines = false, scrollbar = false })<CR>'

    vim.keymap.set('n', key, rhs)
  end
end)

later(function()
  require('mini.move').setup()
end)

later(function()
  require('mini.operators').setup()
end)

later(function()
  require('mini.pick').setup({
    mappings = {
      -- stylua: ignore start
      choose_marked = '<C-CR>',
      delete_word   = '<C-BS>',
      move_down     = '',
      move_start    = '<M-g>',
      move_up       = '',
      scroll_down   = '<C-f>',
      scroll_left   = '<M-f>',
      scroll_right  = '<M-p>',
      scroll_up     = '<C-p>',
      -- stylua: ignore end
    },

    window = {
      config = function()
        -- stylua: ignore start
        local height = math.floor(0.618 * vim.o.lines)
        local width  = math.floor(0.618 * vim.o.columns)
        -- stylua: ignore end

        return {
          -- stylua: ignore start
          anchor = 'NW',
          col    = math.floor(0.5 * (vim.o.columns - width)),
          height = height,
          row    = math.floor(0.5 * (vim.o.lines - height)),
          width  = width,
          -- stylua: ignore end
        }
      end,
    },
  })

  local buffer_pickers = require('vamp.mini.pickers.buffers').setup(MiniPick)

  local buffer_mappings = {
    close_buffer = {
      char = '<C-d>',

      func = function()
        local bufnr = MiniPick.get_picker_matches().current.bufnr

        MiniBufremove.delete(bufnr)

        return true
      end,
    },

    close_marked_buffers = {
      char = '<M-d>',

      func = function()
        local marked_matches = MiniPick.get_picker_matches().marked

        for _, marked_match in ipairs(marked_matches) do
          MiniBufremove.delete(marked_match.bufnr)
        end

        return true
      end,
    },
  }

  vim.keymap.set(
    'n',
    "<Leader>'",
    MiniPick.builtin.resume,
    { desc = 'Resume previous picker', noremap = true }
  )

  vim.keymap.set('n', '<Leader>*', function()
    MiniPick.builtin.grep({
      pattern = vim.fn.expand('<cword>'),
    })
  end, { desc = 'Grep current word', noremap = true })

  vim.keymap.set('n', '<Leader>,', function()
    buffer_pickers.cwd({
      mappings = buffer_mappings,
    })
  end, { desc = 'Buffers (working directory)', noremap = true })

  vim.keymap.set(
    'n',
    '<Leader>/',
    MiniPick.builtin.grep_live,
    { desc = 'Grep', noremap = true }
  )

  vim.keymap.set('n', '<Leader><', function()
    MiniPick.builtin.buffers({
      include_current = false,
    }, {
      mappings = buffer_mappings,
    })
  end, { desc = 'Buffers', noremap = true })

  vim.keymap.set('n', '<Leader>?', function()
    MiniPick.builtin.help({
      default_split = 'vertical',
    })
  end, { desc = 'Help', noremap = true })

  vim.keymap.set(
    'n',
    '<Leader><Space>',
    MiniPick.builtin.files,
    { desc = 'Search files', noremap = true }
  )

  vim.keymap.set('n', '<Leader>nn', function()
    MiniExtra.pickers.buf_lines({
      scope = 'current',
    })
  end, { desc = 'Grep', noremap = true })

  vim.keymap.set(
    'n',
    '<Leader>tt',
    MiniExtra.pickers.buf_lines,
    { desc = 'Grep', noremap = true }
  )
end)

later(function()
  local mini_snippets = require('mini.snippets')

  local latex_patterns = {
    'latex/**/*.json',
    '**/latex.json',
  }

  mini_snippets.setup({
    snippets = {
      mini_snippets.gen_loader.from_file(
        vim.fn.stdpath('config') .. '/snippets/global.json'
      ),

      mini_snippets.gen_loader.from_lang({
        lang_patterns = {
          markdown_inline = {
            'markdown.json',
          },

          -- stylua: ignore start
          plaintex = latex_patterns,
          tex      = latex_patterns,
          -- stylua: ignore end
        },
      }),
    },

    mappings = {
      -- stylua: ignore start
      expand    = '<C-Space>',
      jump_next = '<C-t>',
      jump_prev = '<C-s>',
      stop      = '<Esc>',
      -- stylua: ignore end
    },
  })

  vim.keymap.set('i', '<C-BS>', function()
    local session = MiniSnippets.session.get()

    while MiniSnippets.session.get() do
      MiniSnippets.session.stop()
    end

    vim.cmd('stopinsert')
  end, { noremap = true })

  vim.keymap.set('i', '<C-c>', function()
    while MiniSnippets.session.get() do
      MiniSnippets.session.stop()
    end

    vim.cmd('stopinsert')
    vim.cmd('normal u')
  end, { noremap = true })
end)

later(function()
  require('mini.splitjoin').setup()
end)

later(function()
  require('mini.surround').setup()

  vim.keymap.set('n', '<Leader>xs', function()
    return 'sa'
  end, { desc = 'Add surrounding', expr = true, remap = true })
end)

later(function()
  require('mini.trailspace').setup()

  vim.keymap.set('n', '<Leader>nr', function()
    MiniTrailspace.trim()
    MiniTrailspace.trim_last_lines()
  end, { desc = 'Trim trailspace and last lines', noremap = true })
end)

later(function()
  require('mini.visits').setup()

  vim.keymap.set(
    'n',
    '<Leader>sc',
    MiniVisits.add_label,
    { desc = 'Add label', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>sd',
    MiniVisits.remove_label,
    { desc = 'Remove label', noremap = true }
  )
end)
