return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
         pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pyflakes = { enabled = false },
                pylint = { enabled = false},
              },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = 'on',
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'workspace',
              },
            },
          },
        },
      },
      setup = {
        pyright = function(_, opts)
          local lsp_utils = require 'plugins.lsp.utils'
          lsp_utils.on_attach(function(client, buffer)
            -- stylua: ignore
            if client.name == "pyright" then
              vim.keymap.set("n", "<leader>tC", function() require("dap-python").test_class() end, { buffer = buffer, desc = "Debug Class" })
              vim.keymap.set("n", "<leader>tM", function() require("dap-python").test_method() end, { buffer = buffer, desc = "Debug Method" })
              vim.keymap.set("v", "<leader>tS", function() require("dap-python").debug_selection() end, { buffer = buffer, desc = "Debug Selection" })
            end
          end)
        end,
      },
    },
  },
}
