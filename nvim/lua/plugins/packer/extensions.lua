local log    = require'api.log'
local opts   = require'api.opts'
local paths  = require'api.paths'
local packer = opts.packer

local is_plugin_disabled = function(plugin_path)
  for _, disabled_plugin in ipairs(opts.disabled_plugins) do
    if disabled_plugin:match('%s') ~= nil and plugin_path:find(disabled_plugin, 1, true) ~= nil then
      return true
    end
  end
  return false
end

local get_plugin_config = function(plugin_path, as_name)
  local values_to_strip_from_config_name = {
    '.*/',
    '%.nvim',
    '%-nvim',
    'nvim%.',
    'nvim%-',
    '%.vim',
    '%-vim',
    'vim%.',
    'vim%-'
  }

  local config_name = as_name or plugin_path

  if not as_name then
    for _, value_to_strip_from_config_name in ipairs(values_to_strip_from_config_name) do
      config_name =
        config_name:gsub(value_to_strip_from_config_name, '')
    end
  end

  local config_path =
    packer.relative_plugins_config_path .. '.' .. config_name

  local success, module = pcall(require, config_path)

  log('plugin config retrieved', {
    config_name = config_name,
    config_path = config_path,
    success     = success
  })

  return module
end

local create_spec = function(spec, spec_opts)
  local plugin_path, merge_spec, as_name

  local plugin_is_local   = spec_opts.is_local    or false
  local plugin_has_config = spec_opts.with_config or false

  local ensure_plugin_path = function(plugin_path)
    if plugin_is_local then
      return paths.bundled_plugins .. '/' .. plugin_path
    end

    return plugin_path
  end

  if type(spec) == 'table' then
    plugin_path = ensure_plugin_path(spec[1])
    as_name     = spec.as or nil
    merge_spec  = spec
  else
    plugin_path = ensure_plugin_path(spec)
    as_name     = nil
    merge_spec  = {
      plugin_path
    }
  end

  local plugin_is_disabled = is_plugin_disabled(plugin_path)

  local new_spec = {
    disable = plugin_is_disabled
  }

  if plugin_has_config then
    new_spec.config = get_plugin_config(plugin_path, as_name)
  end

  return vim.tbl_deep_extend('error', merge_spec, new_spec)
end

return function(use)
  local create_use_spec = function(spec_opts)
    return function(spec)
      use(create_spec(spec, spec_opts))
    end
  end

  local use_spec = create_use_spec({
    with_config = true
  })

  local local_use_spec = create_use_spec({
    is_local    = true,
    with_config = true
  })

  local local_use = create_use_spec({
    is_local = true
  })

  return {
    use_spec       = use_spec,
    local_use_spec = local_use_spec,
    local_use      = local_use
  }
end
