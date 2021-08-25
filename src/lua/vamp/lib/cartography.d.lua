---@meta

---@class Cartographer
---@field n set_mode_keymaps
---@field n_with bind_prefix
---@field n_leader set_prefix_mode_keymaps
---@field n_leader_with bind_prefix
---@field x set_mode_keymaps
---@field x_with bind_prefix
---@field x_leader set_prefix_mode_keymaps
---@field x_leader_with bind_prefix
---@field nx set_mode_keymaps
---@field nx_with bind_prefix
---@field nx_leader set_prefix_mode_keymaps
---@field nx_leader_with bind_prefix
---@field nvo set_mode_keymaps
---@field nvo_with bind_prefix
---@field nvo_leader set_prefix_mode_keymaps
---@field nvo_leader_with bind_prefix
---@field i set_mode_keymaps
---@field c set_mode_keymaps
---@field leader string
---@field none string
---@field execute string
---@field command string
---@field cmd string
---@field cr string
---@field esc string
---@field nop string
---@field bs string
---@field space string
---@field tab string
---@field down string
---@field left string
---@field right string
---@field up string
---@field ctrl ModifierKeycode
---@field alt ModifierKeycode
local Cartographer = {}

---@class ModifierKeycode
---@field lhs string
---@field with fun(modifier_keycode: ModifierKeycode, lhs: string): string
local ModifierKeycode = {}

---@alias surround fun(middle: string): string
---@alias partial_modifier_keycode fun(keycode: string): string
---@alias modifier_keycode fun(keycode: string): ModifierKeycode
---@alias set_mode_keymaps fun(keymap_segments: keymap_segments, lhs_prefix: string): nil
---@alias set_lhs_prefix_keymaps fun(lhs_prefix: string): set_lhs_prefix_and_mode_keymaps
---@alias set_lhs_prefix_and_mode_keymaps fun(keymap_segments: keymap_segments, current_lhs_prefix: string): nil

---@alias mode 'n'|'x'|`{ 'n', 'x' }`|''|'i'|'c'
---@alias keymap_segments (string|ModifierKeycode)[]
---@alias keymap [string|ModifierKeycode, string|ModifierKeycode, string]
---@alias keymaps keymap[]

---@alias keymaps_config fun(cartographer: Cartographer): nil
