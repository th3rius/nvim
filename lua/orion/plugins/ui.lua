return {
  {
    -- bufferline
    "akinsho/bufferline.nvim",
    config = function()
      local bufdelete = require("bufdelete").bufdelete
      require("bufferline").setup({
        options = {
          diagnostics = "coc",
          numbers = function(opts)
            return string.format(
              "%s·%s",
              opts.raise(opts.id),
              opts.lower(opts.ordinal)
            )
          end,
          close_command = bufdelete,
        },
      })
    end,
  },

  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    main = "ibl",
    opts = {},
  },

  {
    -- improved vim.ui interfaces
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  {
    -- noicer ui
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = false,
        },
        -- don't show singature when typing, this covers
        -- the entire screen on a simple console.log
        signature = { enabled = false },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
      keys = {
        {
          "<c-f>",
          function()
            if not require("noice.lsp").scroll(4) then
              return "<c-f>"
            end
          end,
          silent = true,
          expr = true,
          desc = "Scroll forward",
          mode = { "i", "n", "s" },
        },
        {
          "<c-b>",
          function()
            if not require("noice.lsp").scroll(-4) then
              return "<c-b>"
            end
          end,
          silent = true,
          expr = true,
          desc = "Scroll backward",
          mode = { "i", "n", "s" },
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },

  {
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvimdev/lspsaga.nvim",
    },
    config = function()
      require("lualine").setup({
        options = {
          component_separators = "|",
          section_separators = "",
        },
        sections = {
          lualine_c = {
            function()
              local bar = require("lspsaga.symbol.winbar").get_bar()
              return bar ~= nil and bar or ""
            end,
          },
          lualine_x = {
            "encoding",
            { "fileformat", padding = { right = 2, left = 1 } },
          },
        },
      })
    end,
  },
}
