return {
  {
    "elixir-tools/elixir-tools.nvim",

    enabled = true,
    ft = "elixir",

    dependencies = {
      "folke/which-key.nvim",
      "nvim-lua/plenary.nvim",
    },

    opts = function(_, _)
      local capabilities = require("cmp_nvim_lsp").default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
          border = "rounded",
        }),

        ["textDocument/signatureHelp"] = vim.lsp.with(
          vim.lsp.handlers.signature_help,
          {
            border = "rounded",
          }
        ),
      }

      return {
        elixirls = {
          cmd = "elixir-ls",
          enable = true,

          capabilities = capabilities,
          handlers = handlers,

          on_attach = function(_, bufnr)
            vim.keymap.set(
              { "n", "x" },
              "<leader>me",
              "<cmd>ElixirExpandMacro<cr>",
              { desc = "Expand macro", buffer = bufnr, noremap = true }
            )

            vim.keymap.set(
              { "n", "x" },
              "<leader>mi",
              ":Mix ",
              { desc = "Mix", buffer = bufnr, noremap = true }
            )

            vim.keymap.set({ "n", "x" }, "<leader>mo", function()
              require("elixir_ls.elixir_ls").open_output_panel({
                window = "float",
              })
            end, {
              desc = "ElixirLS logs",
              buffer = bufnr,
              noremap = true,
            })

            vim.keymap.set(
              { "n", "x" },
              "<leader>mpf",
              "<cmd>ElixirFromPipe<cr>",
              { desc = "From pipe", buffer = bufnr, noremap = true }
            )

            vim.keymap.set(
              { "n", "x" },
              "<leader>mpt",
              "<cmd>ElixirToPipe<cr>",
              { desc = "To pipe", buffer = bufnr, noremap = true }
            )

            vim.keymap.set(
              { "n", "x" },
              "<leader>mre",
              "<cmd>ElixirRestart | edit<cr>",
              {
                desc = "Restart ElixirLS and reattach",
                buffer = bufnr,
                noremap = true,
              }
            )

            vim.keymap.set(
              { "n", "x" },
              "<leader>mrr",
              "<cmd>ElixirRestart<cr>",
              {
                desc = "Restart ElixirLS",
                buffer = bufnr,
                noremap = true,
              }
            )

            vim.keymap.set(
              { "n", "x" },
              "<leader>mrf",
              "<cmd>ElixirRestart | edit!<cr>",
              {
                desc = "" .. " Restart ElixirLS",
                buffer = bufnr,
                noremap = true,
              }
            )

            local to_add = {
              {
                mode = {
                  "n",
                  "x",
                },

                {
                  "<leader>m",
                  group = "",
                },

                {
                  "<leader>mp",
                  name = "Pipes",
                },

                {
                  "<leader>mr",
                  name = "Restart LSP",
                },
              },
            }

            local which_key = require("which-key")

            which_key.add(to_add)
          end,

          settings = require("elixir.elixirls").settings({
            dialyzerEnabled = true,
            enableTestLenses = true,
            fetchDeps = true,
            suggestSpecs = true,
          }),
        },

        nextls = {
          enable = false,

          handlers = handlers,
          capabilities = capabilities,

          init_options = {
            experimental = {
              completions = {
                enable = true,
              },
            },
          },
        },

        projectionist = {
          enable = false,
        },
      }
    end,
  },

  {
    "elixir-editors/vim-elixir",

    ft = "elixir",
  },

  {
    "ngscheurich/edeex.nvim",

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },

    ft = "elixir",

    config = true,
  },
}
