-- stylua: ignore start
local M            = {}
local unpack       = table.unpack or unpack
local cartographer = {}
local leader       = 'leader'
-- stylua: ignore end

setmetatable(cartographer, {
  __index = _G,

  __call = function(self)
    return self
  end,
})

local function title_case(str)
  return str:gsub('^%l', string.upper)
end

local function first_char(str)
  return str:sub(1, 1)
end

local function create_surrounding(left, right)
  return function(middle)
    return left .. middle .. right
  end
end

local surround_special_keycode = create_surrounding('<', '>')

local function create_special_keycode(special_keycode)
  return surround_special_keycode(title_case(special_keycode))
end

local leader_keycode = create_special_keycode(leader)

local function create_partial_modifier_keycode(modifier_key)
  local modifier_keycode = first_char(modifier_key)

  return function(keycode)
    return create_special_keycode(modifier_keycode .. '-' .. keycode)
  end
end

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

local function create_keymaps(modes, keymaps, lhs_prefix)
  for _, keymap in ipairs(keymaps) do
    local lhs, rhs, desc = unpack(keymap)

    local combined_lhs = (lhs_prefix or '') .. tostring(lhs)

    local formatted_rhs

    if type(rhs) == 'table' then
      formatted_rhs = tostring(rhs)
    else
      formatted_rhs = rhs
    end

    vim.keymap.set(modes, combined_lhs, formatted_rhs, {
      desc = desc,
    })
  end
end

local function process_keymap_segments(modes, keymap_segments, lhs_prefix)
  -- stylua: ignore start
  local keymaps = {}
  local keymap  = {}
  -- stylua: ignore end

  assert(
    #keymap_segments % 3 == 0,
    'provided keymaps are not balanced, did you forget a left or right hand side or description?'
  )

  for index, keymap_segment in ipairs(keymap_segments) do
    table.insert(keymap, keymap_segment)

    if index % 3 == 0 then
      table.insert(keymaps, keymap)

      keymap = {}
    end
  end

  create_keymaps(modes, keymaps, lhs_prefix)
end

local function bind_modes(modes)
  return function(keymap_segments, lhs_prefix)
    process_keymap_segments(modes, keymap_segments, lhs_prefix)
  end
end

local function with_prefix(mapper)
  return function(lhs_prefix)
    return function(keymap_segments, current_lhs_prefix)
      local combined_lhs_prefix = (lhs_prefix or '')
        .. (current_lhs_prefix or '')

      mapper(keymap_segments, combined_lhs_prefix)
    end
  end
end

local function init_dsl()
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

      cartographer[mode_name] = bind_modes(mode_value)
    else
      cartographer[mode] = bind_modes(mode)
    end
  end

  -- stylua: ignore start
  local with_key        = '_with'
  local leader_key      = '_' .. leader
  local leader_key_with = leader_key .. with_key
  -- stylua: ignore end

  for _, mode in ipairs({ 'n', 'nx', 'nvo', 'x' }) do
    cartographer[mode .. with_key] = with_prefix(cartographer[mode])

    cartographer[mode .. leader_key] =
      with_prefix(cartographer[mode])(leader_keycode)

    cartographer[mode .. leader_key_with] =
      with_prefix(cartographer[mode .. leader_key])
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

  for _, modifier_key in ipairs({ 'ctrl', 'alt' }) do
    cartographer[modifier_key] =
      create_modifier_keycode(create_partial_modifier_keycode(modifier_key))
  end

  -- stylua: ignore start
  cartographer.leader  = leader_keycode
  cartographer.execute = create_surrounding(cartographer.cmd, cartographer.cr)
  cartographer.command = create_surrounding(':', '')
  -- stylua: ignore end
end

local function eval_in_env(func)
  debug.setfenv(func, cartographer)

  return func()
end

init_dsl()

M.map = function(func)
  return eval_in_env(func)
end

M.remap = function(func)
  return eval_in_env(func)
end

M.diagnostic_whitelist = function()
  local keys = {}

  for key, _ in pairs(cartographer) do
    table.insert(keys, key)
  end

  table.sort(keys)

  return keys
end

return M
