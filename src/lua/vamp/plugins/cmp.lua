return {
	"hrsh7th/nvim-cmp",

	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lsp-document-symbol",
		"hrsh7th/cmp-path",

		"onsails/lspkind.nvim",

		{
			"neovim/nvim-lspconfig",

			config = function()
				require("lspconfig.ui.windows").default_options = {
					border = "rounded",
				}
			end,
		},
	},

	event = {
		"CmdlineEnter",
		"InsertEnter",
	},

	config = function(_, _)
		local cmp = require("cmp")
		local lspkind = require("lspkind")
		local luasnip = require("luasnip")

		local function has_words_before()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))

			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		local function cmp_next_selection_factory(count)
			return function(fallback)
				if cmp.visible() then
					cmp.select_next_item({
						behavior = cmp.SelectBehavior.Select,
						count = count,
					})
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				elseif has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end
		end

		local function cmp_previous_selection_factory(count)
			return function(fallback)
				if cmp.visible() then
					cmp.select_prev_item({
						behavior = cmp.SelectBehavior.Select,
						count = count,
					})
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end
		end

		local cmp_next_selection = cmp_next_selection_factory(1)
		local cmp_previous_selection = cmp_previous_selection_factory(1)
		local cmp_page_down_selection = cmp_next_selection_factory(3)
		local cmp_page_up_selection = cmp_previous_selection_factory(3)

		local cmp_config_window = cmp.config.window.bordered()

		cmp_config_window.border = "none"
		cmp_config_window.col_offset = -3
		cmp_config_window.side_padding = 0

		cmp_config_window.winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:None"

		local function enable_cmp()
			local context = require("cmp.config.context")

			if
				vim.bo.filetype == "TelescopePrompt"
				or context.in_syntax_group("Comment")
				or context.in_treesitter_capture("comment")
			then
				return false
			end

			return true
		end

		cmp.setup({
			completion = {
				autocomplete = false,
			},

			enabled = enable_cmp,

			formatting = {
				fields = {
					"kind",
					"abbr",
					"menu",
				},

				format = function(entry, vim_item)
					local cmp_format_factory = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 80,
					})

					local cmp_format = cmp_format_factory(entry, vim_item)

					local split_kind = vim.split(cmp_format.kind, "%s", {
						trimempty = true,
					})

					local kind = split_kind[1] or ""
					local menu = split_kind[2] or ""

					cmp_format.kind = " " .. kind .. " "
					cmp_format.menu = "    " .. "(" .. menu .. ")"

					return cmp_format
				end,
			},

			mapping = cmp.mapping.preset.insert({
				["<c-bs>"] = cmp.mapping.complete(),

				["<c-a>"] = cmp.mapping.abort(),

				["<c-f>"] = cmp.mapping.scroll_docs(-4),

				["<c-g>"] = function()
					if cmp.visible_docs() then
						cmp.close_docs()
					else
						cmp.open_docs()
					end
				end,

				["<c-p>"] = cmp.mapping.scroll_docs(4),

				["<cr>"] = cmp.mapping.confirm({
					select = false,
					behavior = cmp.ConfirmBehavior.Replace,
				}),

				["<up>"] = cmp.mapping(cmp_previous_selection, {
					"i",
					"s",
				}),

				["<down>"] = cmp.mapping(cmp_next_selection, {
					"i",
					"s",
				}),

				["<tab>"] = cmp.mapping(cmp_next_selection, {
					"i",
					"s",
				}),

				["<s-tab>"] = cmp.mapping(cmp_previous_selection, {
					"i",
					"s",
				}),

				["<pageup>"] = cmp.mapping(cmp_page_up_selection, {
					"i",
					"s",
				}),

				["<pagedown>"] = cmp.mapping(cmp_page_down_selection, {
					"i",
					"s",
				}),
			}),

			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			sources = cmp.config.sources({
				{
					name = "nvim_lsp",
				},

				{
					name = "nvim_lsp_signature_help",
				},

				{
					name = "luasnip",
				},
			}),

			window = {
				completion = cmp_config_window,
				documentation = cmp.config.disable,
			},
		})

		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),

			sources = cmp.config.sources({
				{
					name = "buffer",
				},

				{
					name = "nvim_lsp_document_symbol",
				},
			}),
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),

			sources = cmp.config.sources({
				{
					name = "cmdline",
					option = {
						ignore_cmds = {
							"!",
							"Man",
						},
					},
				},

				window = {
					completion = cmp_config_window,
				},
			}),
		})

		local catppuccin = require("catppuccin.palettes").get_palette(_G.catppuccin_theme)

		vim.api.nvim_set_hl(0, "CmpItemAbbr", {
			bg = "NONE",
			fg = catppuccin.overlay0,
		})

		vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", {
			bg = "NONE",
			fg = catppuccin.overlay0,
			strikethrough = true,
		})

		vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", {
			bg = "NONE",
			fg = catppuccin.green,
			bold = true,
		})

		vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", {
			bg = "NONE",
			fg = catppuccin.green,
			bold = true,
		})

		vim.api.nvim_set_hl(0, "CmpItemMenu", {
			bg = "NONE",
			fg = catppuccin.overlay0,
			italic = true,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindKeyword", {
			bg = catppuccin.lavender,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindClass", {
			bg = catppuccin.red,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindModule", {
			bg = catppuccin.red,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindInterface", {
			bg = catppuccin.red,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindStruct", {
			bg = catppuccin.pink,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindEnum", {
			bg = catppuccin.pink,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindConstant", {
			bg = catppuccin.pink,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindConstructor", {
			bg = catppuccin.maroon,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindFunction", {
			bg = catppuccin.mauve,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindMethod", {
			bg = catppuccin.maroon,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindProperty", {
			bg = catppuccin.peach,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindField", {
			bg = catppuccin.peach,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", {
			bg = catppuccin.peach,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindEvent", {
			bg = catppuccin.flamingo,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindOperator", {
			bg = catppuccin.flamingo,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", {
			bg = catppuccin.flamingo,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindVariable", {
			bg = catppuccin.teal,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindReference", {
			bg = catppuccin.teal,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindValue", {
			bg = catppuccin.sky,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindUnit", {
			bg = catppuccin.sky,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindSnippet", {
			bg = catppuccin.sapphire,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindText", {
			bg = catppuccin.sapphire,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindFolder", {
			bg = catppuccin.blue,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindFile", {
			bg = catppuccin.yellow,
			fg = catppuccin.base,
		})

		vim.api.nvim_set_hl(0, "CmpItemKindColor", {
			bg = catppuccin.rosewater,
			fg = catppuccin.base,
		})
	end,
}
