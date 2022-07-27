local classy   = {}
classy.default = {}
classy.setters = {}

function classy.default.field_separator()
  return '_'
end

function classy.default.setter_prefix()
  return 'set'
end

function classy.setters.noop(_, _, curr_val, _)
  return curr_val
end

function classy.setters.tg_field_value(_, _, curr_val, _)
  return not curr_val
end

function classy.setters.set_field_to_value(_, _, _, val)
  return val
end

function classy.setters.set_field_to_key(_, field_key, _, _)
  return field_key
end

function classy.conjoin(tbls)
  for key1, tbl1 in pairs(tbls) do
    if type(tbl1) == 'table' then
      for key2, tbl2 in pairs(tbls) do
        if key1 ~= key2 then
          rawset(tbl1, key2, tbl2)
        end
      end
    end
  end
  return tbls
end

function classy.get_opt(field_opts, opts, opt, default)
  return field_opts[opt] or opts[opt] or default
end

function classy.get_opts(field_key, field_opts, opts)
  field_opts = field_opts or {}
  opts       = opts or {}

  local function get_opt(opt, default)
    return classy.get_opt(field_opts, opts, opt, default)
  end

  local getter_prefix   = get_opt('getter_prefix', 'get')
  local setter_prefix   = get_opt('setter_prefix', classy.default.setter_prefix())
  local default         = get_opt('default', false)
  local setter_fn       = get_opt('setter_fn', classy.setters.set_field_to_value)
  local no_dict         = get_opt('no_dict', false)
  local values          = get_opt('values', false)
  local no_getter       = get_opt('no_getter', false)
  local field_separator = classy.default.field_separator()

  local function get_field_key(prefix)
    if #prefix == 0 then
      return field_key
    end

    return prefix .. field_separator .. field_key
  end

  local getter_key = get_field_key(getter_prefix)
  local setter_key = get_field_key(setter_prefix)

  return {
    getter_key    = getter_key,
    setter_key    = setter_key,
    default       = default,
    setter_fn     = setter_fn,
    no_dict       = no_dict,
    no_getter     = no_getter,
    values        = values,
    getter_prefix = getter_prefix,
    setter_prefix = setter_prefix
  }
end

function classy.create_stn_field(tbl, field_key, create)
  local stn_field = rawget(tbl, field_key)
  if stn_field == nil and create then
    rawset(tbl, field_key, {})
    stn_field = rawget(tbl, field_key)
  end
  return stn_field
end

function classy.create_stn_fields(tbl, opts)
  local dict = classy.create_stn_field(tbl, '__dict', not opts.no_dict)
  local vals = classy.create_stn_field(tbl, '__values', opts.values)
  return dict, vals
end

function classy.create_field(tbl, field_key, field_opts, tbl_opts)
  local opts       = classy.get_opts(field_key, field_opts, tbl_opts)
  local dict, vals = classy.create_stn_fields(tbl, opts)

  if not opts.no_dict then
    rawset(dict, field_key, opts.default)

    if not opts.no_getter then
      rawset(tbl, opts.getter_key, function()
        return rawget(dict, field_key)
      end)
    end
  end

  if opts.values and opts.default then
    table.insert(vals, opts.default)
  end

  rawset(tbl, opts.setter_key, function(val)
    local curr_val = ''
    local new_val  = ''

    if not opts.no_dict then
      curr_val = rawget(dict, field_key)
    end

    if type(opts.setter_fn) == 'function' then
      new_val = opts.setter_fn(tbl, field_key, curr_val, val)
    else
      new_val = opts.setter_fn
    end

    if not opts.no_dict then
      rawset(dict, field_key, new_val)
    end

    if opts.values and new_val then
      table.insert(vals, new_val)
    end

    return tbl
  end)

  return tbl
end

function classy.create_fields(tbl, fields, opts)
  for key, val in pairs(fields) do
    local field_key  = (type(key) == 'number' and val) or key
    local field_opts = (type(val) == 'table' and val) or nil
    classy.create_field(tbl, field_key, field_opts, opts)
  end
  return tbl
end

function classy.create_dynamic_fields(fields, field_opts, opts)
  local setter_prefix =
  classy.get_opt(field_opts, opts, 'setter_prefix',
  classy.default.setter_prefix())

  return setmetatable(classy.create(fields, opts), {
    __index = function(tbl, key)
      return function()
        local setter = rawget(tbl, key)
        if setter == nil then
          local field_separator = classy.default.field_separator()
          local new_key         = key:gsub(setter_prefix .. field_separator, '')

          classy.create_field(tbl, new_key, field_opts, opts)

          setter = rawget(tbl, key)
        end
        return setter()
      end
    end
  })
end

function classy.create(fields, opts)
  return classy.create_fields({}, fields, opts)
end

return classy
