local bind = require("keybinder")

return {
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- SchemaStore catalog for use with jsonls
      "b0o/schemastore.nvim",

      -- Useful status updates for LSP.
      { "j-hui/fidget.nvim", config = true },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { "folke/neodev.nvim", config = true },

      -- Pure lua replacement for `typescript-language-server`
      {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        config = true,
      },
    },
    config = function()
      local telescope_builtin = require("telescope.builtin")
      local schemastore = require("schemastore")

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup(
          "orion-lsp-attach",
          { clear = true }
        ),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Jump to the definition of the word under your cursor.
          bind.n("gd", telescope_builtin.lsp_definitions, "Goto definition")

          -- Find references for the word under your cursor.
          bind.n("gr", telescope_builtin.lsp_references, "Goto references")

          -- Jump to the implementation of the word under your cursor.
          bind.n(
            "gI",
            telescope_builtin.lsp_implementations,
            "Goto implementation"
          )

          -- Jump to the type of the word under your cursor.
          bind.n(
            "<leader>D",
            telescope_builtin.lsp_type_definitions,
            "Type definition"
          )

          -- Fuzzy find all the symbols in your current document.
          bind.n(
            "<leader>ds",
            telescope_builtin.lsp_document_symbols,
            "Document symbols"
          )

          -- Fuzzy find all the symbols in your current workspace.
          bind.n(
            "<leader>ws",
            telescope_builtin.lsp_dynamic_workspace_symbols,
            "Workspace symbols"
          )

          -- Rename the variable under your cursor.
          bind.n("<leader>r", vim.lsp.buf.rename, "Rename")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          bind.n("<leader>a", vim.lsp.buf.code_action, "Code action")

          -- Opens a popup that displays documentation about the word under your cursor
          bind.n("K", vim.lsp.buf.hover, "Hover documentation")

          -- Jump to the declaration of the word under your cursor.
          bind.n("gD", vim.lsp.buf.declaration, "Goto declaration")

          -- Highlight symbol on cursor hold
          if
            client and client.server_capabilities.documentHighlightProvider
          then
            local highlight_augroup = vim.api.nvim_create_augroup(
              "orion-lsp-highlight",
              { clear = false }
            )
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup(
                "orion-lsp-detach",
                { clear = true }
              ),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({
                  buffer = event2.buf,
                })
              end,
            })
          end

          if
            client
            and client.server_capabilities.inlayHintProvider
            and vim.lsp.inlay_hint
          then
            bind.n("<leader>th>", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
            end, "Toggle inlay hints")
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      -- By default, Neovim doesn't support everything that is in the LSP specification.
      -- When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      -- So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend(
        "force",
        capabilities,
        require("cmp_nvim_lsp").default_capabilities()
      )

      -- Enable the following language servers
      local servers = {
        lua_ls = {},

        rust_analyzer = {},

        html = {},
        cssls = {},
        cssmodules_ls = {},

        jsonls = {
          settings = {
            json = {
              schemas = schemastore.json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                -- The built-in schemaStore must be disable for use with `b0o/schemastore`
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = "",
              },
              schemas = schemastore.yaml.schemas(),
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      require("mason").setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
      })
      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
      })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend(
              "force",
              {},
              capabilities,
              server.capabilities or {}
            )
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },

  {
    -- Improved LSP experience
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup({
        lightbulb = {
          enable = false,
        },
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
}
