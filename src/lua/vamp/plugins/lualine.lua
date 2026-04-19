return {
  "nvim-lualine/lualine.nvim",

  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  opts = function(_, _)
    local catppuccin =
      require("catppuccin.palettes").get_palette(_G.catppuccin_theme)

    local conditions = {
      is_buffer_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,

      should_hide = function()
        return vim.fn.winwidth(0) > 80
      end,
    }

    local opts = {
      options = {
        component_separators = "",
        section_separators = "",

        disabled_filetypes = {
          "lazy",
          "qf",
          "trouble",
          "DiffviewFiles",
          "DiffviewFileHistory",
          "TelescopePrompt",
        },

        theme = {
          normal = {
            c = {
              fg = catppuccin.text,
              bg = catppuccin.mantle,
            },
          },

          inactive = {
            c = {
              fg = catppuccin.text,
              bg = catppuccin.mantle,
            },
          },
        },
      },

      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },

      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
    }

    local function insert_into_left_section(component)
      table.insert(opts.sections.lualine_c, component)
    end

    local function insert_into_right_section(component)
      table.insert(opts.sections.lualine_x, component)
    end

    insert_into_left_section({
      function()
        return "▊"
      end,

      color = {
        fg = catppuccin.blue,
      },

      padding = {
        left = 0,
        right = 1,
      },
    })

    insert_into_left_section({
      function()
        return "󰣐 "
      end,

      color = function()
        local mode_color = {
          n = catppuccin.red,
          i = catppuccin.green,
          v = catppuccin.blue,
          r = catppuccin.teal,
          s = catppuccin.peach,
          t = catppuccin.red,
          c = catppuccin.mauve,

          ce = catppuccin.red,
          cv = catppuccin.red,
          ic = catppuccin.yellow,
          no = catppuccin.red,
          rm = catppuccin.teal,

          R = catppuccin.lavender,
          S = catppuccin.peach,
          V = catppuccin.blue,

          Rv = catppuccin.lavender,

          [""] = catppuccin.peach,
          [""] = catppuccin.blue,

          ["r?"] = catppuccin.teal,

          ["!"] = catppuccin.red,
        }

        return {
          fg = mode_color[vim.fn.mode()],
        }
      end,

      padding = {
        right = 1,
      },
    })

    insert_into_left_section({
      "filesize",

      cond = conditions.is_buffer_empty,

      color = {
        fg = catppuccin.subtext0,
        gui = "bold",
      },
    })

    insert_into_left_section({
      "filename",

      cond = conditions.is_buffer_empty,

      color = {
        fg = catppuccin.mauve,
        gui = "bold",
      },
    })

    insert_into_left_section({
      "filetype",

      cond = conditions.is_buffer_empty,
      icon_only = true,

      color = {
        fg = catppuccin.mauve,
      },
    })

    insert_into_left_section({
      "location",

      color = {
        fg = catppuccin.subtext0,
      },
    })

    insert_into_left_section({
      "progress",

      color = {
        fg = catppuccin.subtext0,
        gui = "bold",
      },
    })

    insert_into_left_section({
      "diagnostics",

      sources = {
        "nvim_diagnostic",
      },

      symbols = {
        error = " ",
        hint = "󰮥 ",
        info = " ",
        warn = " ",
      },

      diagnostics_color = {
        color_error = {
          fg = catppuccin.red,
        },

        color_hint = {
          fg = catppuccin.teal,
        },

        color_info = {
          fg = catppuccin.blue,
        },

        color_warn = {
          fg = catppuccin.yellow,
        },
      },
    })

    insert_into_left_section({
      function()
        return "%="
      end,
    })

    insert_into_right_section({
      "o:encoding",

      cond = conditions.should_hide,

      color = {
        fg = catppuccin.green,
        gui = "bold",
      },
    })

    insert_into_right_section({
      "fileformat",

      icons_enabled = true,

      color = {
        fg = catppuccin.green,
        gui = "bold",
      },
    })

    insert_into_right_section({
      "branch",

      icon = " ",

      color = {
        fg = catppuccin.lavender,
        gui = "bold",
      },

      fmt = function(section)
        if string.len(section) > 1 then
          local split = vim.split(section, "/")

          if table.maxn(split) > 1 then
            return split[1]
          end
        end

        return section
      end,
    })

    insert_into_right_section({
      "diff",

      cond = conditions.should_hide,

      diff_color = {
        added = {
          fg = catppuccin.green,
        },

        modified = {
          fg = catppuccin.yellow,
        },

        removed = {
          fg = catppuccin.red,
        },
      },

      symbols = {
        added = " ",
        modified = "󰝤 ",
        removed = " ",
      },
    })

    insert_into_right_section({
      function()
        return "▊"
      end,

      color = {
        fg = catppuccin.blue,
      },

      padding = {
        left = 1,
      },
    })

    return opts
  end,
}
