---`cartography` allows you to set keymaps in a fun and proscriptive manner using
---a custom DSL built on the meta-programming features provided by **Lua**.
local M = {}

---The unadorned **leader** keycode.
local LEADER = 'leader'

---Converts the provided `str` to title case.
---@param str string
---@return string titled_cased_str
local function to_title_case(str)
  local result, _ = str:gsub('^%l', string.upper)

  return result
end

---Gets the first character of the provided `str`.
---@param str string
---@return string first_char
local function get_first_char(str)
  return str:sub(1, 1)
end

---Creates a partially applied function used to create a surrounding from the
---provided `left` and `right` arguments.
---@param left string
---@param right string
---@return surround surround
local function create_surrounding(left, right)
  return function(middle)
    return left .. middle .. right
  end
end

---A partially applied function used to surround a keycode.
---That is, with angle brackets, to create a 'special' keycode.
local surround_special_keycode = create_surrounding('<', '>')

---Creates a 'special' keycode from the provided `keycode`.
---That is, a keycode, converted to title case, surrounded by angle brackets.
---@param keycode string
---@return string special_keycode
local function create_special_keycode(keycode)
  return surround_special_keycode(to_title_case(keycode))
end

---The **<Leader>** keycode.
local leader_keycode = create_special_keycode(LEADER)

---Creates a partially applied function used to create a 'modifier' keycode
---from the provided `modifier_key`.
---That is, the first character of the modifier key, suffixed with a dash and
---a provided `keycode` and surrounded by angle brackets.
---@param modifier_key string
---@return partial_modifier_keycode partial_modifier_keycode
local function create_partial_modifier_keycode(modifier_key)
  local modifier_keycode = get_first_char(modifier_key)

  return function(keycode)
    return create_special_keycode(modifier_keycode .. '-' .. keycode)
  end
end

---Creates a partially applied function used to create a 'modifier' keycode
---from the provided `partial_modifier_keycode`.
---That is, a table that holds the state of the modifier keycode.
---@param partial_modifier_keycode partial_modifier_keycode
---@return modifier_keycode modifier_keycode
local function create_modifier_keycode(partial_modifier_keycode)
  return function(keycode)
    return setmetatable({
      lhs = partial_modifier_keycode(keycode),

      with = function(self, lhs)
        self.lhs = self.lhs .. lhs

        return self
      end,
    }, {
      __tostring = function(self)
        return self.lhs
      end,
    })
  end
end

---Sets keymaps from the provided `mode`, `keymaps` and `lhs_prefix`.
---@param mode mode
---@param keymaps keymaps
---@param lhs_prefix string
---@return nil
local function set_keymaps(mode, keymaps, lhs_prefix)
  for _, keymap in ipairs(keymaps) do
    local lhs, rhs, desc = unpack(keymap)

    vim.keymap.set(mode, (lhs_prefix or '') .. tostring(lhs), tostring(rhs), {
      desc = desc,
    })
  end
end

---Creates `keymaps` by iterating over the provided `keymap_segments` in chunks
---of three to build each individual `keymap`, returning a new array of said
---`keymaps`.
---@param keymap_segments keymap_segments
---@return keymaps keymaps
local function create_keymaps(keymap_segments)
  local keymaps = {}
  local keymap = {}

  assert(
    #keymap_segments % 3 == 0,
    'provided `keymap_segments` are not balanced, did you forget a left or right hand side or description?'
  )

  for index, keymap_segment in ipairs(keymap_segments) do
    table.insert(keymap, keymap_segment)

    if index % 3 == 0 then
      table.insert(keymaps, keymap)

      keymap = {}
    end
  end

  return keymaps
end

---Creates a partially applied function used to set keymaps from the provided
---`mode`.
---@param mode mode
---@return set_mode_keymaps set_mode_keymaps
local function create_set_mode_keymaps(mode)
  return function(keymap_segments, lhs_prefix)
    set_keymaps(mode, create_keymaps(keymap_segments), lhs_prefix)
  end
end

---Creates a partially applied function used to set keymaps from the provided
---`set_mode_keymaps` (also a partially applied function) with a provided
---`lhs_prefix`.
---@param set_mode_keymaps set_mode_keymaps
---@return set_lhs_prefix_keymaps set_lhs_prefix_keymaps
local function create_set_lhs_prefix_keymaps(set_mode_keymaps)
  return function(lhs_prefix)
    return function(keymap_segments, current_lhs_prefix)
      local combined_lhs_prefix = (lhs_prefix or '')
        .. (current_lhs_prefix or '')

      set_mode_keymaps(keymap_segments, combined_lhs_prefix)
    end
  end
end

---@return Cartographer cartographer
local function create_cartographer()
  local cartographer = {}

  for _, mode in ipairs({
    'n',
    'x',
    { 'nx', { 'n', 'x' } },
    { 'nvo', '' },
    'i',
    'c',
  }) do
    if type(mode) == 'table' then
      local mode_name, mode_value = unpack(mode)

      cartographer[mode_name] = create_set_mode_keymaps(mode_value)
    else
      cartographer[mode] = create_set_mode_keymaps(mode)
    end
  end

  local with_key = '_with'
  local leader_key = '_' .. LEADER
  local leader_key_with = leader_key .. with_key

  for _, mode in ipairs({
    'n',
    'nx',
    'nvo',
    'x',
  }) do
    cartographer[mode .. with_key] =
      create_set_lhs_prefix_keymaps(cartographer[mode])

    cartographer[mode .. leader_key] =
      create_set_lhs_prefix_keymaps(cartographer[mode])(leader_keycode)

    cartographer[mode .. leader_key_with] =
      create_set_lhs_prefix_keymaps(cartographer[mode .. leader_key])
  end

  for _, special_keycode in ipairs({
    'cmd',
    'cr',
    'esc',
    'nop',
    'bs',
    'space',
    'tab',
    'down',
    'left',
    'right',
    'up',
  }) do
    cartographer[special_keycode] = create_special_keycode(special_keycode)
  end

  for _, modifier_key in ipairs({
    'ctrl',
    'alt',
  }) do
    cartographer[modifier_key] =
      create_modifier_keycode(create_partial_modifier_keycode(modifier_key))
  end

  cartographer.leader = leader_keycode
  cartographer.none = ''
  cartographer.execute = create_surrounding(cartographer.cmd, cartographer.cr)
  cartographer.command = create_surrounding(':', '')

  --Sets the `__index` field of the metatable of `cartographer` to the global
  --table. Ensures that global values can be called within a function that is
  --evaluated within the environment of `cartographer`.
  setmetatable(cartographer, {
    __index = _G,
  })

  return cartographer
end

local cartographer = create_cartographer()

---Evalutes the provided `keymaps_config` function in the environment of
---`cartographer`.
---@param keymaps_config keymaps_config
---@return `M`
local function eval_in_env(keymaps_config)
  assert(
    keymaps_config and type(keymaps_config) == 'function',
    'provided `keymap_config` must be a function'
  )

  debug.setfenv(keymaps_config, cartographer)

  keymaps_config(cartographer)

  return M
end

---Sets keymaps configured within the provided `keymaps_config` non-recursively.
---@param keymaps_config keymaps_config
---@return `M`
function M.noremap(keymaps_config)
  return eval_in_env(keymaps_config)
end

---Sets keymaps configured within the provided `keymaps_config` recursively.
---@param keymaps_config keymaps_config
---@return `M`
function M.remap(keymaps_config)
  return eval_in_env(keymaps_config)
end

---Gets an array of symbol names that should be added to the **lua_ls** LSP
---configuration.
---Specifically the diagnostics globals whitelist.
---This will ensure no false positives are raised with the usage of
---`Cartography`.
---
---Example LSP configuration:
---```
---{
---  settings = {
---    Lua = {
---      diagnostics = {
---        globals = require('cartographer').diagnostics_globals_whitelist()
---      }
---    }
---  }
---}
---```
---@return string[] diagnostics_globals_whitelist
function M.diagnostics_globals_whitelist()
  local keys = {}

  for key, _ in pairs(cartographer) do
    table.insert(keys, key)
  end

  table.sort(keys)

  return keys
end

return M
