if not vim.g.neovide then
  return
end

vim.g.neovide_cursor_animation_length = 0.0
vim.g.neovide_cursor_trail_size = 0.0
vim.g.neovide_floating_blur_amount_x = 0.0
vim.g.neovide_floating_blur_amount_y = 0.0
vim.g.neovide_floating_shadow = false
vim.g.neovide_fullscreen = true
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_position_animation_length = 0.0
vim.g.neovide_remember_window_size = true
vim.g.neovide_scroll_animation_far_lines = 9999
vim.g.neovide_transparency = 1

vim.keymap.set("c", "<c-v>", "<c-r>+")
vim.keymap.set("i", "<c-v>", '<esc>l"+Pli')
vim.keymap.set("n", "<c-v>", '"+P')
vim.keymap.set("v", "<c-c>", '"+y')
vim.keymap.set("v", "<c-v>", '"+P')
