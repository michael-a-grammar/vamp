local M = {}

local function get_buffers(opts)
  return vim.iter(vim.fn.getbufinfo({ buflisted = 1 })):filter(function(bufinfo)
    return vim.tbl_isempty(bufinfo.windows) or opts.include_current
  end)
end

local function map_buffers(buffers, only_cwd)
  local cwd = vim.fn.getcwd()

  return buffers
    :map(function(bufinfo)
      local relpath = vim.fs.relpath(cwd, bufinfo.name)

      if only_cwd and not relpath then
        return nil
      end

      return {
        -- stylua: ignore start
        bufnr = bufinfo.bufnr,
        text  = relpath or bufinfo.name,
        -- stylua: ignore end
      }
    end)
    :totable()
end

local function pick(minipick, buffers, subtitle, opts)
  minipick.start(vim.tbl_deep_extend('keep', opts, {
    source = {
      -- stylua: ignore start
      name  = 'Buffers ' .. subtitle,
      items = buffers,
      -- stylua: ignore end

      show = function(buf_id, items_to_show, query)
        minipick.default_show(buf_id, items_to_show, query, {
          show_icons = true,
        })
      end,
    },
  }))
end

local function pick_cwd_buffers(minipick, opts)
  opts = opts or {}

  local buffers = get_buffers(opts)

  return pick(minipick, map_buffers(buffers, true), '(working directory)', opts)
end

local function pick_non_cwd_buffers(minipick, opts)
  opts = opts or {}

  local cwd_buffers = map_buffers(get_buffers(opts), true)

  local non_cwd_buffers = get_buffers(opts):filter(function(buffer)
    return not vim.tbl_contains(cwd_buffers, function(cwd_buffer)
      return cwd_buffer.bufnr == buffer.bufnr
    end, { predicate = true })
  end)

  return pick(
    minipick,
    map_buffers(non_cwd_buffers, false),
    '(non-working directory)',
    opts
  )
end

M.setup = function(minipick)
  -- stylua: ignore start
  minipick.registry.cwd_buffers     = pick_cwd_buffers
  minipick.registry.non_cwd_buffers = pick_non_cwd_buffers
  -- stylua: ignore end

  return M
end

function M.cwd(minipick, opts)
  pick_cwd_buffers(minipick, opts)
end

function M.non_cwd(minipick, opts)
  pick_non_cwd_buffers(minipick, opts)
end

return M
