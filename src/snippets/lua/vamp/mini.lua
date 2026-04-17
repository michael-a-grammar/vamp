local new_autocmd = require("vamp.lib.new_autocmd")
local safely = require("vamp.lib.safely")

local now, now_if_args, later = safely.now, safely.now_if_args, safely.later

vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

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

  vim.keymap.set({ "n", "x" }, "<leader>sc", function()
    vim.ui.input({ prompt = "Session name: " }, MiniSessions.write)
  end, { desc = "New session", noremap = true })

  vim.keymap.set({ "n", "x" }, "<leader>sd", function()
    MiniSessions.select("delete")
  end, { desc = "Delete session", noremap = true })

  vim.keymap.set(
    { "n", "x" },
    "<leader>sr",
    MiniSessions.restart,
    { desc = "Restart session", noremap = true }
  )

  vim.keymap.set({ "n", "x" }, "<leader>ss", function()
    MiniSessions.select("read")
  end, { desc = "Read session", noremap = true })

  vim.keymap.set(
    { "n", "x" },
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
      reset = "q",
      reveal_cwd = "@",
      show_help = "g?",
      synchronize = "w",
      trim_left = "<",
      trim_right = ">",
    },

    windows = {
      preview = true,
    },
  })

  new_autocmd("User", "MiniFilesExplorerOpen", function()
    MiniFiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working directory" })
  end, "Add bookmarks to MiniFiles")
end)
