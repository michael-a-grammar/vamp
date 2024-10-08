return {
  'nvim-telescope/telescope.nvim',

  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'nvim-telescope/telescope-github.nvim',
    'nvim-telescope/telescope-z.nvim',

    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
  },

  opts = function(_, _)
    local pickers = {
      'buffers',
      'colorscheme',
      'command_history',
      'commands',
      'current_buffer_fuzzy_find',
      'diagnostics',
      'find_files',
      'git_bcommits',
      'git_branches',
      'git_commits',
      'git_files',
      'git_stash',
      'git_status',
      'grep_string',
      'highlights',
      'help_tags',
      'jumplist',
      'keymaps',
      'live_grep',
      'loclist',
      'lsp_definitions',
      'lsp_document_symbols',
      'lsp_dynamic_workspace_symbols',
      'lsp_implementations',
      'lsp_references',
      'lsp_workspace_symbols',
      'marks',
      'oldfiles',
      'pickers',
      'quickfix',
      'quickfixhistory',
      'registers',
      'search_history',
      'spell_suggest',
      'treesitter',
      'vim_options',
      'workspace_symbols',
    }

    local pickers_configuration = {}

    for _, picker in ipairs(pickers) do
      pickers_configuration[picker] = {
        theme = 'ivy',
      }
    end

    local actions = require('telescope.actions')
    local trouble = require('trouble.sources.telescope')

    return {
      defaults = {
        mappings = {
          i = {
            ['dd'] = actions.close,

            ['<a-q>'] = actions.send_selected_to_qflist + actions.open_qflist,

            ['<c-a>'] = trouble.open,
            ['<c-f>'] = actions.preview_scrolling_up,
            ['<c-h>'] = actions.select_horizontal,
            ['<c-p>'] = actions.preview_scrolling_down,
            ['<c-t>'] = actions.select_tab,

            ['<c-r><c-c>'] = actions.insert_original_cline,

            ['<c-left>'] = actions.preview_scrolling_left,
            ['<c-right>'] = actions.preview_scrolling_right,

            ['<tab>'] = actions.toggle_selection + actions.move_selection_worse,
            ['<left>'] = actions.results_scrolling_left,
            ['<right>'] = actions.results_scrolling_right,
          },

          n = {
            ['<a-q>'] = actions.send_selected_to_qflist + actions.open_qflist,

            ['<c-a>'] = trouble.open,
            ['<c-f>'] = actions.preview_scrolling_up,
            ['<c-h>'] = actions.select_horizontal,
            ['<c-p>'] = actions.preview_scrolling_down,
            ['<c-t>'] = actions.select_tab,

            ['<c-r><c-c>'] = actions.insert_original_cline,

            ['<c-left>'] = actions.preview_scrolling_left,
            ['<c-right>'] = actions.preview_scrolling_right,

            ['<tab>'] = actions.toggle_selection + actions.move_selection_worse,
            ['<left>'] = actions.results_scrolling_left,
            ['<right>'] = actions.results_scrolling_right,
          },
        },

        path_display = {
          truncate = 1,
        },
      },

      extensions = {
        file_browser = {
          mappings = {
            ['i'] = {
              ['<tab>'] = function(prompt_bufnr)
                actions.toggle_selection(prompt_bufnr)
                actions.move_selection_worse(prompt_bufnr)
              end,
            },

            ['n'] = {
              ['<tab>'] = function(prompt_bufnr)
                actions.toggle_selection(prompt_bufnr)
                actions.move_selection_worse(prompt_bufnr)
              end,
            },
          },

          theme = 'ivy',
        },
      },

      pickers = pickers_configuration,
    }
  end,

  config = function(_, opts)
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')
    local buffer_dir = require('telescope.utils').buffer_dir

    local catppuccin =
      require('catppuccin.palettes').get_palette(_G.catppuccin_theme)

    telescope.setup(opts)

    telescope.load_extension('file_browser')
    telescope.load_extension('fzf')
    telescope.load_extension('gh')
    telescope.load_extension('yank_history')
    telescope.load_extension('z')

    vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', {
      bg = catppuccin.green,
      fg = catppuccin.crust,
    })

    vim.api.nvim_set_hl(0, 'TelescopePromptTitle', {
      bg = catppuccin.red,
      fg = catppuccin.crust,
    })

    vim.api.nvim_set_hl(0, 'TelescopeResultsTitle', {
      bg = catppuccin.lavender,
      fg = catppuccin.crust,
    })

    local file_browser = telescope.extensions.file_browser.file_browser
    local yank_ring_history = telescope.extensions.yank_history.yank_history

    local create_get_buffers = function(only_cwd)
      return function()
        builtin.buffers({
          ignore_current_buffer = true,
          only_cwd = only_cwd,
          sort_mru = true,
        })
      end
    end

    local get_buffers_only_cwd = create_get_buffers(true)
    local get_buffers = create_get_buffers(false)

    vim.keymap.set(
      { 'n', 'x' },
      "<leader>'",
      builtin.resume,
      { desc = 'Resume Telescope', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>*',
      builtin.grep_string,
      { desc = '' .. ' Grep w/input', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>,',
      get_buffers_only_cwd,
      { desc = '' .. ' Buffers', noremap = true }
    )

    vim.keymap.set({ 'n', 'x' }, '<leader>.', function()
      builtin.find_files({
        cwd = buffer_dir(),
      })
    end, { desc = '' .. ' Find files', noremap = true })

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>/',
      builtin.live_grep,
      { desc = '' .. ' Grep', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader><',
      get_buffers,
      { desc = 'Buffers', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>?',
      builtin.help_tags,
      { desc = 'Help tags', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader><space>',
      builtin.find_files,
      { desc = '' .. ' Find files', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>ei',
      builtin.lsp_implementations,
      { desc = 'Implementations', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>en',
      builtin.lsp_dynamic_workspace_symbols,
      { desc = 'Dynamic workspace symbols', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>ew',
      builtin.lsp_workspace_symbols,
      { desc = 'Workspace symbols', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>f/',
      builtin.search_history,
      { desc = 'Search history', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>f:',
      builtin.command_history,
      { desc = 'Command history', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>fc',
      builtin.quickfixhistory,
      { desc = 'Quickfix history', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>ff',
      builtin.oldfiles,
      { desc = '' .. ' Recent files', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>fm',
      builtin.marks,
      { desc = 'Marks', noremap = true }
    )

    vim.keymap.set({ 'n', 'x' }, '<leader>fr', function()
      builtin.oldfiles({
        only_cwd = true,
      })
    end, { desc = '' .. ' Recent files', noremap = true })

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>fu',
      builtin.jumplist,
      { desc = 'Jumps', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>nn',
      builtin.current_buffer_fuzzy_find,
      { desc = 'Fuzzy find', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>ns',
      builtin.lsp_document_symbols,
      { desc = 'Document symbols', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>nt',
      builtin.treesitter,
      { desc = 'Treesitter', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>pc',
      builtin.spell_suggest,
      { desc = 'Spelling suggestions', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>pr',
      builtin.registers,
      { desc = 'Registers', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>pyh',
      yank_ring_history,
      { desc = 'Yank ring history', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>s*',
      builtin.grep_string,
      { desc = 'Grep w/input', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>s/',
      builtin.live_grep,
      { desc = 'Grep', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>sd',
      file_browser,
      { desc = 'File browser', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>ss',
      builtin.find_files,
      { desc = 'Find files', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>tt',
      get_buffers_only_cwd,
      { desc = '' .. ' Buffers', noremap = true }
    )

    vim.keymap.set({ 'n', 'x' }, '<leader>u*', function()
      builtin.grep_string({
        cwd = buffer_dir(),
      })
    end, { desc = 'Grep w/input', noremap = true })

    vim.keymap.set({ 'n', 'x' }, '<leader>u/', function()
      builtin.live_grep({
        cwd = buffer_dir(),
      })
    end, { desc = 'Grep', noremap = true })

    vim.keymap.set({ 'n', 'x' }, '<leader>ud', function()
      file_browser({
        path = buffer_dir(),
      })
    end, { desc = 'File browser', noremap = true })

    vim.keymap.set({ 'n', 'x' }, '<leader>uu', function()
      builtin.find_files({
        cwd = buffer_dir(),
      })
    end, { desc = 'Find files', noremap = true })

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>z:',
      builtin.commands,
      { desc = 'Commands', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>zc',
      builtin.colorscheme,
      { desc = 'Colourschemes', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>zh',
      builtin.highlights,
      { desc = 'Highlights', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>zk',
      builtin.keymaps,
      { desc = 'Keymaps', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>zl',
      builtin.reloader,
      { desc = 'Lua modules', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>zo',
      builtin.vim_options,
      { desc = 'Options', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>gsb',
      builtin.git_branches,
      { desc = 'Branches', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>gsc',
      builtin.git_commits,
      { desc = 'Commits', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>gsf',
      builtin.git_files,
      { desc = 'Files', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>gsg',
      builtin.git_status,
      { desc = 'Status', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>gsr',
      builtin.git_bcommits,
      { desc = 'Branch commits', noremap = true }
    )

    vim.keymap.set(
      { 'n', 'x' },
      '<leader>gss',
      builtin.git_stash,
      { desc = 'Stash', noremap = true }
    )

    local get_file_info = function()
      local buffer_number = vim.api.nvim_get_current_buf()
      local file_type = vim.filetype.match({ buf = buffer_number })

      if not file_type then
        return false
      end

      local file_extension = vim.fn.expand('%:e')

      return {
        type = file_type,
        extension = file_extension,
      }
    end

    local get_find_command = function()
      return { 'rg', '--type', get_file_info().type, '--files' }
    end

    local get_filters = function(cwd)
      local file_info = get_file_info()

      if not file_info then
        return {}
      end

      local filters = {
        glob_pattern = '*.' .. file_info.extension .. '*',
        type_filter = file_info.type,
      }

      if cwd then
        filters.cwd = buffer_dir()
      end

      return filters
    end

    vim.keymap.set({ 'n', 'x' }, '<leader>stf', function()
      builtin.find_files({
        find_command = get_find_command(),
      })
    end, { desc = 'Find files', noremap = true })

    vim.keymap.set({ 'n', 'x' }, '<leader>sts', function()
      builtin.live_grep(get_filters(false))
    end, { desc = 'Grep', noremap = true })

    vim.keymap.set({ 'n', 'x' }, '<leader>utf', function()
      builtin.find_files({
        find_command = get_find_command(),
        cwd = buffer_dir(),
      })
    end, { desc = 'Find files', noremap = true })

    vim.keymap.set({ 'n', 'x' }, '<leader>uts', function()
      builtin.live_grep(get_filters(true))
    end, { desc = 'Grep', noremap = true })
  end,
}
