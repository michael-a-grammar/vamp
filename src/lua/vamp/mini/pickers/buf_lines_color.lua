local M = {}

M.register = function()
  local namespace = vim.api.nvim_create_namespace('buf-lines-color')

  local buf_lines_color = function(buf_id, items, query, opts)
    if items == nil or #items == 0 then
      return
    end

    MiniPick.default_show(buf_id, items, query, opts)

    local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)

    local digit_prefixes = {}

    for i, l in ipairs(lines) do
      local _, prefix_end, prefix = l:find('^(%s*%d+│)')

      if prefix_end ~= nil then
        digit_prefixes[i], lines[i] = prefix, l:sub(prefix_end + 1)
      end
    end

    vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)

    for i, prefix in pairs(digit_prefixes) do
      local opts = {
        virt_text = {
          {
            prefix,
            'LineNr',
          },
        },

        virt_text_pos = 'inline',
      }

      vim.api.nvim_buf_set_extmark(buf_id, namespace, i - 1, 0, opts)
    end

    local filetype = vim.bo[items[1].bufnr].filetype

    local has_lang, lang = pcall(vim.treesitter.language.get_lang, filetype)

    local has_treesitter, _ =
      pcall(vim.treesitter.start, buf_id, has_lang and lang or filetype)

    if not has_treesitter and filetype then
      vim.bo[buf_id].syntax = filetype
    end
  end

  MiniPick.registry.buf_lines_color = function()
    MiniExtra.pickers.buf_lines({
      scope = 'current',
    }, {
      source = {
        show = buf_lines_color,
      },
    })
  end
end

return M
