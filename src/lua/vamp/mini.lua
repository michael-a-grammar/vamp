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
  local miniicons = require('mini.icons')

  local ext3_blocklist = {
    scm = true,
    txt = true,
    yml = true,
  }

  local ext4_blocklist = {
    json = true,
    yaml = true,
  }

  miniicons.setup({
    use_file_extension = function(ext, _)
      return not (ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)])
    end,
  })

  later(miniicons.mock_nvim_web_devicons)
  later(miniicons.tweak_lsp_kind)
end)

now(function()
  local mininotify = require('mini.notify')

  mininotify.setup({
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
    mininotify.clear,
    { desc = 'Clear notifications', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>hn',
    mininotify.show_history,
    { desc = 'Notifications', noremap = true }
  )
end)

now(function()
  local minisessions = require('mini.sessions')

  minisessions.setup()

  vim.keymap.set('n', '<Leader>uc', function()
    vim.ui.input({ prompt = 'Session name: ' }, minisessions.write)
  end, { desc = 'New session', noremap = true })

  vim.keymap.set('n', '<Leader>ud', function()
    minisessions.select('delete')
  end, { desc = 'Delete session', noremap = true })

  vim.keymap.set('n', '<Leader>uu', function()
    minisessions.select('read')
  end, { desc = 'Read session', noremap = true })

  vim.keymap.set(
    'n',
    '<Leader>uw',
    minisessions.write,
    { desc = 'Write session', noremap = true }
  )
end)

now(function()
  require('mini.starter').setup()
end)

now(function()
  local ministatusline = require('mini.statusline')

  ministatusline.setup({
    content = {
      active = function()
        local mode, mode_hl = ministatusline.section_mode({ trunc_width = 120 })

        local mode_icon = ' '

        if string.lower(mode) == 'terminal' then
          mode_icon = ' '
        end

        local filename = ministatusline.section_filename({ trunc_width = 140 })

        return ministatusline.combine_groups({
          {
            -- stylua: ignore start
            hl      = mode_hl,
            strings = { mode_icon },
            -- stylua: ignore end
          },

          '%<',

          {
            -- stylua: ignore start
            hl      = 'MiniStatuslineFilename',
            strings = { filename },
            -- stylua: ignore end
          },

          '%=',
        })
      end,

      inactive = nil,
    },
  })
end)

now(function()
  require('mini.statuscolumn').setup({
    dim_inactive = false,
  })
end)

now_if_args(function()
  local minicompletion = require('mini.completion')

  minicompletion.setup({
    delay = {
      -- stylua: ignore start
      completion = 10^7,
      info       = 100,
      signature  = 50,
      -- stylua: ignore end
    },

    lsp_completion = {
      -- stylua: ignore start
      auto_setup  = false,
      source_func = 'omnifunc',
      -- stylua: ignore end

      process_items = function(items, base)
        return minicompletion.default_process_items(items, base, {
          kind_priority = {
            -- stylua: ignore start
            Text    = -1,
            Snippet = 99,
            -- stylua: ignore end
          },
        })
      end,
    },

    mappings = {
      -- stylua: ignore start
      force_fallback = '<C-CR>',
      force_twostep  = '<C-Space>',
      scroll_down    = '<C-f>',
      scroll_up      = '<C-p>',
      -- stylua: ignore end
    },
  })

  new_autocmd('LspAttach', nil, function(args)
    vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
  end)

  vim.lsp.config('*', {
    capabilities = minicompletion.get_lsp_capabilities(),
  })
end)

now_if_args(function()
  local minifiles = require('mini.files')

  minifiles.setup({
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

  local function minifiles_toggle(minifiles_open)
    if not minifiles.close() then
      minifiles_open()
    end
  end

  vim.keymap.set('n', '<Leader>ff', function()
    minifiles_toggle(function()
      minifiles.open(vim.api.nvim_buf_get_name(0), false)
    end)
  end, { desc = 'Files (buffer directory)', noremap = true })

  vim.keymap.set('n', '<Leader>ft', function()
    minifiles_toggle(function()
      minifiles.open(nil, false)
    end)
  end, { desc = 'Files (working directory)', noremap = true })

  vim.keymap.set('n', '<Leader>l', function()
    minifiles_toggle(minifiles.open)
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

    minifiles.refresh({
      content = {
        filter = show_dotfiles and filters.show or filters.hide,
      },
    })
  end

  local function toggle_preview()
    show_preview = not show_preview

    minifiles.refresh({
      windows = {
        preview = show_preview,
      },
    })
  end

  local function split_win_keymap(buf_id, lhs, direction, desc)
    local function rhs()
      local target_window = minifiles.get_explorer_state().target_window

      local new_target = vim.api.nvim_win_call(target_window, function()
        vim.cmd(direction .. ' split')

        return vim.api.nvim_get_current_win()
      end)

      minifiles.go_in()
      minifiles.set_target_window(new_target)
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

  local function set_bookmark(id, path, desc)
    if vim.uv.fs_stat(vim.fn.expand(path)) then
      minifiles.set_bookmark(id, path, { desc = desc })
    end
  end

  new_autocmd('User', 'MiniFilesExplorerOpen', function()
    set_bookmark('~', '~/', 'Home')
    set_bookmark('c', vim.fn.getcwd(), 'Working directory')

    for _, bookmark in ipairs(_G.vamp.private.bookmarks) do
      set_bookmark(bookmark.id, bookmark.path, bookmark.desc)
    end
  end, 'Add bookmarks to MiniFiles')
end)

now_if_args(function()
  local minimisc = require('mini.misc')

  minimisc.setup({
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
    minimisc.resize_window,
    { desc = 'Resize window to editable width', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>z',
    minimisc.zoom,
    { desc = 'Zoom', noremap = true }
  )

  minimisc.setup_auto_root()
  minimisc.setup_restore_cursor()
  minimisc.setup_termbg_sync()
end)

later(function()
  local miniextra = require('mini.extra')
  local minipick = require('mini.pick')

  miniextra.setup()

  vim.keymap.set('n', 'gd', function()
    miniextra.pickers.lsp({
      scope = 'definition',
    })
  end, { desc = 'Definition', noremap = true })

  vim.keymap.set('n', 'ld', function()
    miniextra.pickers.lsp({
      scope = 'definition',
    })
  end, { desc = 'Definition', noremap = true })

  vim.keymap.set('n', 'lee', function()
    miniextra.pickers.diagnostic({
      scope = 'current',
    })
  end, { desc = 'Diagnostics (buffer)', noremap = true })

  vim.keymap.set('n', 'let', function()
    miniextra.pickers.diagnostic({
      scope = 'all',
    })
  end, { desc = 'Diagnostics (all)', noremap = true })

  vim.keymap.set('n', 'li', function()
    miniextra.pickers.lsp({
      scope = 'implementation',
    })
  end, { desc = 'Implementation', noremap = true })

  vim.keymap.set('n', 'll', function()
    miniextra.pickers.lsp({
      scope = 'document_symbol',
    }, { source = { name = 'blah' } })

    require('vamp.lib.poll_until')(minipick.is_picker_active, function()
      local items = minipick.get_picker_items()

      if items ~= nil then
        local new_items = vim
          .iter(items)
          :filter(function(item)
            return string.lower(item.kind) == 'function'
          end)
          :totable()

        -- minipick.set_picker_items(new_items)
      end
    end)
  end, { desc = 'Document symbols', noremap = true })

  vim.keymap.set('n', 'lr', function()
    miniextra.pickers.lsp({
      scope = 'references',
    })
  end, { desc = 'References', noremap = true })

  vim.keymap.set('n', 'ls', function()
    miniextra.pickers.lsp({
      scope = 'workspace_symbol_live',
    })
  end, { desc = 'Workspace symbols (live)', noremap = true })

  vim.keymap.set('n', 'lt', function()
    miniextra.pickers.lsp({
      scope = 'type_definition',
    })
  end, { desc = 'Type definition', noremap = true })

  vim.keymap.set('n', '<Leader>.', function()
    miniextra.pickers.explorer({
      cwd = vim.fn.expand('%:h'),
    })
  end, { desc = 'Explorer (buffer directory)', noremap = true })

  vim.keymap.set(
    'n',
    '<Leader>>',
    miniextra.pickers.explorer,
    { desc = 'Explorer (working directory)', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>@c',
    miniextra.pickers.git_commits,
    { desc = 'Commits', noremap = true }
  )

  vim.keymap.set('n', '<Leader>@hh', function()
    miniextra.pickers.git_hunks({
      scope = 'unstaged',
    })
  end, { desc = 'Unstaged hunks', noremap = true })

  vim.keymap.set('n', '<Leader>@hu', function()
    miniextra.pickers.git_hunks({
      scope = 'staged',
    })
  end, { desc = 'Staged hunks', noremap = true })

  vim.keymap.set('n', '<Leader>fc', function()
    miniextra.pickers.list({
      scope = 'change',
    })
  end, { desc = 'Change list', noremap = true })

  vim.keymap.set('n', '<Leader>fl', function()
    miniextra.pickers.list({
      scope = 'location',
    })
  end, { desc = 'Location list', noremap = true })

  vim.keymap.set(
    'n',
    '<Leader>fm',
    miniextra.pickers.marks,
    { desc = 'Marks', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>fo',
    miniextra.pickers.oldfiles,
    { desc = 'Old files (global)', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>fp',
    miniextra.pickers.hipatterns,
    { desc = 'Highlight patterns', noremap = true }
  )

  vim.keymap.set('n', '<Leader>fq', function()
    miniextra.pickers.list({
      scope = 'quickfix',
    })
  end, { desc = 'Quickfix list', noremap = true })

  vim.keymap.set('n', '<Leader>fr', function()
    miniextra.pickers.oldfiles({
      current_dir = true,
    })
  end, { desc = 'Old files (working directory)', noremap = true })

  vim.keymap.set('n', '<Leader>fu', function()
    miniextra.pickers.list({
      scope = 'jump',
    })
  end, { desc = 'Jump list', noremap = true })

  vim.keymap.set(
    'n',
    '<Leader>fv',
    miniextra.pickers.visit_paths,
    { desc = 'Visits', noremap = true }
  )

  vim.keymap.set('n', '<Leader>gc', function()
    miniextra.pickers.git_commits({
      path = vim.fn.expand('%'),
    })
  end, { desc = 'Commits', noremap = true })

  vim.keymap.set('n', '<Leader>ghh', function()
    miniextra.pickers.git_hunks({
      -- stylua: ignore start
      path  = vim.fn.expand("%"),
      scope = 'unstaged',
      -- stylua: ignore end
    })
  end, { desc = 'Unstaged hunks', noremap = true })

  vim.keymap.set('n', '<Leader>ghu', function()
    miniextra.pickers.git_hunks({
      -- stylua: ignore start
      path  = vim.fn.expand("%"),
      scope = 'staged',
      -- stylua: ignore end
    })
  end, { desc = 'Staged hunks', noremap = true })

  vim.keymap.set('n', '<Leader>h/', function()
    miniextra.pickers.history({
      scope = '/',
    })
  end, { desc = 'Searches', noremap = true })

  vim.keymap.set('n', '<Leader>h:', function()
    miniextra.pickers.history({
      scope = ':',
    })
  end, { desc = 'Commands', noremap = true })

  vim.keymap.set('n', '<Leader>nh', function()
    miniextra.pickers.hipatterns({
      scope = 'current',
    })
  end, { desc = 'Highlight patterns', noremap = true })

  vim.keymap.set('n', '<Leader>nm', function()
    miniextra.pickers.marks({
      scope = 'buf',
    })
  end, { desc = 'Marks', noremap = true })

  vim.keymap.set(
    'n',
    '<Leader>ns',
    miniextra.pickers.spellsuggest,
    { desc = 'Spelling suggestions', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>ss',
    miniextra.pickers.visit_labels,
    { desc = 'Labels', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>v"',
    miniextra.pickers.registers,
    { desc = 'Registers', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>v:',
    miniextra.pickers.commands,
    { desc = 'Commands', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>vc',
    miniextra.pickers.colorschemes,
    { desc = 'Colour schemes', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>vh',
    miniextra.pickers.hl_groups,
    { desc = 'Highlight groups', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>vk',
    miniextra.pickers.keymaps,
    { desc = 'Keymaps', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>vm',
    miniextra.pickers.manpages,
    { desc = 'Manpages', noremap = true }
  )

  vim.keymap.set('n', '<Leader>vo', function()
    miniextra.pickers.options({
      scope = 'all',
    })
  end, { desc = 'Options', noremap = true })
end)

later(function()
  -- stylua: ignore start
  local miniai    = require('mini.ai')
  local miniextra = require('mini.extra')
  -- stylua: ignore end

  miniai.setup({
    mappings = {
      around_last = 'ap',
      inside_last = 'ip',
    },

    custom_textobjects = {
      ['#'] = miniextra.gen_ai_spec.number(),

      ['%'] = miniextra.gen_ai_spec.buffer(),

      ['.'] = miniextra.gen_ai_spec.line(),

      a = miniai.gen_spec.argument(),

      c = miniai.gen_spec.function_call(),

      d = miniextra.gen_ai_spec.diagnostic(),

      f = miniai.gen_spec.treesitter({
        a = '@function.outer',
        i = '@function.inner',
      }),

      i = miniextra.gen_ai_spec.indent(),

      k = miniai.gen_spec.treesitter({
        a = '@block.outer',
        i = '@block.inner',
      }),

      o = miniai.gen_spec.treesitter({
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
  local minibracketed = require('mini.bracketed')

  minibracketed.setup()

  vim.keymap.set('n', '<Leader>tn', function()
    minibracketed.buffer('forward')
  end, { desc = 'Next buffer', noremap = true })

  vim.keymap.set('n', '<Leader>tp', function()
    minibracketed.buffer('backward')
  end, { desc = 'Previous buffer', noremap = true })

  vim.keymap.set('n', '<Leader>wf', function()
    minibracketed.window('first')
  end, { desc = 'First window', noremap = true })

  vim.keymap.set('n', '<Leader>wl', function()
    minibracketed.window('last')
  end, { desc = 'Last window', noremap = true })

  vim.keymap.set('n', '<Leader>wn', function()
    minibracketed.window('forward')
  end, { desc = 'Next window', noremap = true })

  vim.keymap.set('n', '<Leader>wp', function()
    minibracketed.window('backward')
  end, { desc = 'Previous window', noremap = true })

  vim.keymap.set('n', '<C-r>', '"+', { noremap = true })
end)

later(function()
  local minibufremove = require('mini.bufremove')

  minibufremove.setup()

  vim.keymap.set(
    'n',
    '<Leader>nd',
    minibufremove.delete,
    { desc = 'Close buffer', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>nw',
    minibufremove.wipeout,
    { desc = 'Wipeout buffer', noremap = true }
  )

  vim.keymap.set('n', '<Leader>nx', function()
    minibufremove.delete(0, true)
  end, { desc = 'Force close buffer', noremap = true })

  vim.keymap.set('n', '<Leader>td', function()
    for _, bufinfo in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
      local bufnr = bufinfo.bufnr

      if vim.bo[bufnr].buftype ~= '' then
        minibufremove.delete(bufnr)
      end
    end
  end, {
    desc = 'Close all buffers',
    noremap = true,
  })
end)

later(function()
  local miniclue = require('mini.clue')

  miniclue.setup({
    clues = {
      {
        -- stylua: ignore start
        { mode =   'n',        keys = 'la',         desc = '+Actions'                 },
        { mode =   'n',        keys = 'le',         desc = '+Diagnostics'             },
        { mode =   'n',        keys = '<Leader>@',  desc = '+Git (working directory)' },
        { mode =   'n',        keys = '<Leader>@a', desc = '+Actions'                 },
        { mode =   'n',        keys = '<Leader>@d', desc = '+Diff'                    },
        { mode =   'n',        keys = '<Leader>@h', desc = '+Hunks'                   },
        { mode = { 'n', 'x' }, keys = '<Leader>c',  desc = '+Context'                 },
        { mode =   'n',        keys = '<Leader>f',  desc = '+Navigation'              },
        { mode = { 'n', 'x' }, keys = '<Leader>g',  desc = '+Git (buffer)'            },
        { mode =   'n',        keys = '<Leader>ga', desc = '+Actions'                 },
        { mode =   'n',        keys = '<Leader>gd', desc = '+Diff'                    },
        { mode = { 'n', 'x' }, keys = '<Leader>gh', desc = '+Hunks'                   },
        { mode =   'n',        keys = '<Leader>h',  desc = '+History'                 },
        { mode =   'n',        keys = '<Leader>i',  desc = '+Map'                     },
        { mode =   'n',        keys = '<Leader>k',  desc = '+Toggles'                 },
        { mode =   'n',        keys = '<Leader>n',  desc = '+Buffer'                  },
        { mode =   'n',        keys = '<Leader>nf', desc = '+Path'                    },
        { mode =   'n',        keys = '<Leader>q',  desc = '+Quit'                    },
        { mode =   'n',        keys = '<Leader>r',  desc = '+Terminal'                },
        { mode =   'n',        keys = '<Leader>ra', desc = '+Applications'            },
        { mode =   'n',        keys = '<Leader>s',  desc = '+Visits'                  },
        { mode =   'n',        keys = '<Leader>t',  desc = '+Buffers'                 },
        { mode =   'n',        keys = '<Leader>u',  desc = '+Session'                 },
        { mode =   'n',        keys = '<Leader>v',  desc = '+Vim'                     },
        { mode =   'n',        keys = '<Leader>w',  desc = '+Windows'                 },
        { mode = { 'n', 'x' }, keys = '<Leader>x',  desc = '+Text'                    },
        { mode = { 'n', 'x' }, keys = '<Leader>xs', desc = '+Surroundings'            },
        { mode =   'n',        keys = '<Leader>y',  desc = '+Tabpages'                },
        { mode =   'n',        keys = '<Leader>ym', desc = '+Move'                    },

        { mode = 'n', keys = '<BS>c', postkeys = '<BS>' },
        { mode = 'n', keys = '<BS>i', postkeys = '<BS>' },
        { mode = 'n', keys = '<BS>n', postkeys = '<BS>' },
        { mode = 'n', keys = '<BS>p', postkeys = '<BS>' },

        { mode = 'n', keys = '<Leader>ghf', postkeys = '<Leader>gh' },
        { mode = 'n', keys = '<Leader>ghl', postkeys = '<Leader>gh' },
        { mode = 'n', keys = '<Leader>ghn', postkeys = '<Leader>gh' },
        { mode = 'n', keys = '<Leader>ghp', postkeys = '<Leader>gh' },
        { mode = 'n', keys = '<Leader>kb',  postkeys = '<Leader>k'  },
        { mode = 'n', keys = '<Leader>kc',  postkeys = '<Leader>k'  },
        { mode = 'n', keys = '<Leader>kd',  postkeys = '<Leader>k'  },
        { mode = 'n', keys = '<Leader>kh',  postkeys = '<Leader>k'  },
        { mode = 'n', keys = '<Leader>ki',  postkeys = '<Leader>k'  },
        { mode = 'n', keys = '<Leader>kl',  postkeys = '<Leader>k'  },
        { mode = 'n', keys = '<Leader>kn',  postkeys = '<Leader>k'  },
        { mode = 'n', keys = '<Leader>ko',  postkeys = '<Leader>k'  },
        { mode = 'n', keys = '<Leader>kr',  postkeys = '<Leader>k'  },
        { mode = 'n', keys = '<Leader>ks',  postkeys = '<Leader>k'  },
        { mode = 'n', keys = '<Leader>kt',  postkeys = '<Leader>k'  },
        { mode = 'n', keys = '<Leader>kw',  postkeys = '<Leader>k'  },
        { mode = 'n', keys = '<Leader>tn',  postkeys = '<Leader>t'  },
        { mode = 'n', keys = '<Leader>tp',  postkeys = '<Leader>t'  },
        { mode = 'n', keys = '<Leader>wf',  postkeys = '<Leader>w'  },
        { mode = 'n', keys = '<Leader>wl',  postkeys = '<Leader>w'  },
        { mode = 'n', keys = '<Leader>wn',  postkeys = '<Leader>w'  },
        { mode = 'n', keys = '<Leader>wp',  postkeys = '<Leader>w'  },
        { mode = 'n', keys = '<Leader>ws',  postkeys = '<Leader>w'  },
        { mode = 'n', keys = '<Leader>wv',  postkeys = '<Leader>w'  },
        { mode = 'n', keys = '<Leader>yf',  postkeys = '<Leader>y'  },
        { mode = 'n', keys = '<Leader>yl',  postkeys = '<Leader>y'  },
        { mode = 'n', keys = '<Leader>yn',  postkeys = '<Leader>y'  },
        { mode = 'n', keys = '<Leader>yp',  postkeys = '<Leader>y'  },
      },

      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.square_brackets(),

      miniclue.gen_clues.windows({
        -- stylua: ignore start
        submode_move     = true,
        submode_navigate = true,
        submode_resize   = true,
        -- stylua: ignore end
      }),

      miniclue.gen_clues.z(),
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
      { mode =   'n',        keys = 'l'        },
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
  local minidiff = require('mini.diff')

  minidiff.setup()

  vim.keymap.set('n', '<Leader>gar', function()
    return minidiff.operator('reset') .. '_'
  end, { desc = 'Reset line', expr = true, remap = true })

  vim.keymap.set('n', '<Leader>gas', function()
    return minidiff.operator('apply') .. '_'
  end, { desc = 'Stage line', expr = true, remap = true })

  vim.keymap.set(
    'n',
    '<Leader>gg',
    minidiff.toggle_overlay,
    { desc = 'Toggle overlay', noremap = true }
  )

  vim.keymap.set('n', '<Leader>ghf', function()
    minidiff.goto_hunk('first')
  end, { desc = 'First hunk', noremap = true })

  vim.keymap.set('n', '<Leader>ghl', function()
    minidiff.goto_hunk('last')
  end, { desc = 'Last hunk', noremap = true })

  vim.keymap.set('n', '<Leader>ghn', function()
    minidiff.goto_hunk('next')
  end, { desc = 'Next hunk', noremap = true })

  vim.keymap.set('n', '<Leader>ghp', function()
    minidiff.goto_hunk('prev')
  end, { desc = 'Previous hunk', noremap = true })

  vim.keymap.set('n', '<Leader>ghr', function()
    return minidiff.operator('reset') .. 'gh'
  end, { desc = 'Reset hunk', expr = true, remap = true })

  vim.keymap.set('n', '<Leader>ghs', function()
    return minidiff.operator('apply') .. 'gh'
  end, { desc = 'Stage hunk', expr = true, remap = true })

  vim.keymap.set(
    'x',
    '<Leader>ghr',
    'gH',
    { desc = 'Reset hunk', remap = true }
  )

  vim.keymap.set(
    'x',
    '<Leader>ghs',
    'gh',
    { desc = 'Stage hunk', remap = true }
  )
end)

later(function()
  local minigit = require('mini.git')

  minigit.setup()

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
    minigit.show_range_history({
      -- stylua: ignore start
      line_start = 1,
      line_end   = vim.api.nvim_buf_line_count(0),
      -- stylua: ignore end
    })
  end, { desc = 'Show history', noremap = true })

  vim.keymap.set(
    'n',
    '<Leader>gk',
    minigit.show_at_cursor,
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
    minigit.show_at_cursor,
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
  -- stylua: ignore start
  local minihipatterns = require('mini.hipatterns')
  local words           = require('mini.extra').gen_highlighter.words
  -- stylua: ignore end

  minihipatterns.setup({
    highlighters = {
      hex_color = minihipatterns.gen_highlighter.hex_color(),

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
    'Vai',
    { desc = 'Visually select around indent scope', remap = true }
  )

  vim.keymap.set(
    'x',
    '<Leader>xi',
    'ai',
    { desc = 'Select around indent scope', remap = true }
  )
end)

later(function()
  require('mini.input').setup()
end)

later(function()
  local minijump = require('mini.jump')

  minijump.setup({
    delay = {
      highlight = 500,
      idle_stop = 2000000,
    },
  })

  vim.keymap.set({ 'n', 'x', 'o' }, '<Esc>', function()
    if not minijump.state.jumping then
      return '<Esc>'
    end

    minijump.stop_jumping()
  end, { expr = true, remap = true })
end)

later(function()
  local minijump2d = require('mini.jump2d')

  minijump2d.setup({
    labels = 'ntesiroamghdkvclpufxzufq',

    mappings = {
      start_jumping = '',
    },

    view = {
      dim = true,
    },
  })

  local start_opts = minijump2d.builtin_opts.word_start

  local function start_minijump2d(current)
    minijump2d.start(vim.tbl_deep_extend('force', start_opts, {
      allowed_lines = {
        -- stylua: ignore start
        cursor_before = true,
        cursor_at     = true,
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
    start_minijump2d(true)
  end, { desc = 'Jump (current window)', noremap = true })

  vim.keymap.set({ 'n', 'x' }, '<BS>w', function()
    start_minijump2d(false)
  end, { desc = 'Jump (other windows)', noremap = true })
end)

later(function()
  local minikeymap = require('mini.keymap')

  minikeymap.setup()

  minikeymap.map_combo('n', '<Esc><Esc>', function()
    vim.cmd.normal({ 'zzzH', bang = true })

    vim.cmd('nohlsearch')
  end)

  minikeymap.map_combo('i', 'kk', '<BS><BS><Esc>[s1z=gi<Right>')

  minikeymap.map_multistep('i', '<Tab>', {
    'pmenu_next',
  })

  minikeymap.map_multistep('i', '<S-Tab>', {
    'pmenu_prev',
  })
end)

later(function()
  local minimap = require('mini.map')

  minimap.setup({
    integrations = {
      minimap.gen_integration.builtin_search(),
      minimap.gen_integration.diff(),
      minimap.gen_integration.diagnostic(),
    },

    symbols = {
      encode = minimap.gen_encode_symbols.dot('4x2'),
    },
  })

  vim.keymap.set(
    'n',
    '<Leader>if',
    minimap.toggle_focus,
    { desc = 'Focus', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>ii',
    minimap.toggle,
    { desc = 'Toggle', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>ir',
    minimap.refresh,
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

  vim.keymap.set(
    'n',
    '<Leader>x(',
    'gxiagxipa',
    { remap = true, desc = 'Swap argument left' }
  )

  vim.keymap.set(
    'n',
    '<Leader>x)',
    'gxiagxina',
    { remap = true, desc = 'Swap argument right' }
  )
end)

later(function()
  -- stylua: ignore start
  local minipick      = require('mini.pick')
  local minibufremove = require('mini.bufremove')
  local miniextra     = require('mini.extra')
  -- stylua: ignore end

  local buffer_pickers = require('vamp.mini.pickers.buffers').setup(minipick)

  minipick.setup({
    mappings = {
      -- stylua: ignore start
      choose_marked = '<C-CR>',
      delete_word   = '<C-w>',
      move_down     = '',
      move_start    = '<C-g>',
      move_up       = '',
      scroll_down   = '<C-f>',
      scroll_left   = '<M-f>',
      scroll_right  = '<M-p>',
      scroll_up     = '<C-p>',
      -- stylua: ignore end

      refresh = {
        char = '<M-g>',

        func = function()
          minipick.refresh()

          return false
        end,
      },
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

  local buffer_mappings = {
    close_buffer = {
      char = '<C-d>',

      func = function()
        local bufnr = minipick.get_picker_matches().current.bufnr

        minibufremove.delete(bufnr)

        return true
      end,
    },

    close_marked_buffers = {
      char = '<M-d>',

      func = function()
        local marked_matches = minipick.get_picker_matches().marked

        for _, marked_match in ipairs(marked_matches) do
          minibufremove.delete(marked_match.bufnr)
        end

        return true
      end,
    },
  }

  vim.keymap.set(
    'n',
    "<Leader>'",
    minipick.builtin.resume,
    { desc = 'Resume previous picker', noremap = true }
  )

  vim.keymap.set('n', '<Leader>*', function()
    minipick.builtin.grep({
      pattern = vim.fn.expand('<cword>'),
    })
  end, { desc = 'Grep (current word)', noremap = true })

  vim.keymap.set('n', '<Leader>,', function()
    buffer_pickers.cwd(minipick, {
      mappings = buffer_mappings,
    })
  end, { desc = 'Buffers (working directory)', noremap = true })

  vim.keymap.set(
    'n',
    '<Leader>/',
    minipick.builtin.grep_live,
    { desc = 'Grep', noremap = true }
  )

  vim.keymap.set('n', '<Leader><', function()
    minipick.builtin.buffers({
      include_current = false,
    }, {
      mappings = buffer_mappings,
    })
  end, { desc = 'Buffers', noremap = true })

  vim.keymap.set('n', '<Leader>?', function()
    minipick.builtin.help({
      default_split = 'vertical',
    })
  end, { desc = 'Help', noremap = true })

  vim.keymap.set(
    'n',
    '<Leader><Space>',
    minipick.builtin.files,
    { desc = 'Search files', noremap = true }
  )

  vim.keymap.set('n', '<Leader>nn', function()
    miniextra.pickers.buf_lines({
      scope = 'current',
    })
  end, { desc = 'Grep', noremap = true })

  vim.keymap.set(
    'n',
    '<Leader>tt',
    miniextra.pickers.buf_lines,
    { desc = 'Grep', noremap = true }
  )
end)

later(function()
  local minisnippets = require('mini.snippets')

  local latex_patterns = {
    'latex/**/*.json',
    '**/latex.json',
  }

  minisnippets.setup({
    snippets = {
      minisnippets.gen_loader.from_file(
        vim.fn.stdpath('config') .. '/snippets/global.json'
      ),

      minisnippets.gen_loader.from_lang({
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
      expand    = '',
      jump_next = '<C-s>',
      jump_prev = '<C-t>',
      stop      = '<Esc>',
      -- stylua: ignore end
    },
  })

  vim.keymap.set('i', '<C-BS>', function()
    while minisnippets.session.get() do
      minisnippets.session.stop()

      vim.cmd('stopinsert')

      vim.cmd.normal({ 'u', bang = true })
    end
  end, { noremap = true })

  vim.keymap.set('i', '<C-c>', function()
    while minisnippets.session.get() do
      minisnippets.session.stop()

      vim.cmd('stopinsert')
    end
  end, { noremap = true })

  minisnippets.start_lsp_server()
end)

later(function()
  require('mini.splitjoin').setup()
end)

later(function()
  require('mini.surround').setup({
    mappings = {
      suffix_last = 'p',
    },
  })

  vim.keymap.set(
    { 'n', 'x' },
    '<Leader>xsa',
    'sa',
    { desc = 'Add surrounding', remap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>xsd',
    'sd',
    { desc = 'Delete surrounding', remap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>xsh',
    'sd',
    { desc = 'Highlight surrounding', remap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>xsr',
    'sr',
    { desc = 'Replace surrounding', remap = true }
  )
end)

later(function()
  local minitrailspace = require('mini.trailspace')

  minitrailspace.setup()

  vim.keymap.set('n', '<Leader>ni', function()
    minitrailspace.trim()
    minitrailspace.trim_last_lines()
  end, { desc = 'Trim trailspace and last lines', noremap = true })
end)

later(function()
  local minivisits = require('mini.visits')

  minivisits.setup()

  vim.keymap.set(
    'n',
    '<Leader>sc',
    minivisits.add_label,
    { desc = 'Add label', noremap = true }
  )

  vim.keymap.set(
    'n',
    '<Leader>sd',
    minivisits.remove_label,
    { desc = 'Remove label', noremap = true }
  )
end)
