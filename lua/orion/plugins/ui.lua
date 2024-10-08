return {
  {
    -- bufferline
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    config = function()
      local bufdelete = require("bufdelete").bufdelete
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
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
    main = "ibl",
    opts = {
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "lazy",
          "mason",
          "toggleterm",
        },
      },
    },
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
      { "MunifTanjim/nui.nvim", lazy = true },
    },
  },

  {
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvimdev/lspsaga.nvim",
    },
    config = function()
      local noice = require("noice")

      local function fg(name)
        return function()
          local hl = vim.api.nvim_get_hl_by_name(name, true)
          return hl
            and hl.foreground
            and { fg = string.format("#%06x", hl.foreground) }
        end
      end

      require("lualine").setup({
        options = {
          component_separators = "|",
          section_separators = "",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = {
            statusline = { "alpha" },
          },
        },
        sections = {
          lualine_c = {
            function()
              local bar = require("lspsaga.symbol.winbar").get_bar()
              return bar ~= nil and bar or ""
            end,
          },
          lualine_x = {
            {
              function()
                return noice.api.status.command.get()
              end,
              cond = function()
                return noice.api.status.command.has()
              end,
              color = fg("Statement"),
            },
            {
              function()
                return noice.api.status.mode.get()
              end,
              cond = function()
                return noice.api.status.mode.has()
              end,
              color = fg("Constant"),
            },
            {
              function()
                return vim.api.nvim_call_function("SleuthIndicator", {})
              end,
            },
            "encoding",
            { "fileformat", padding = { left = 1, right = 1 } },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
      })
    end,
  },

  -- icons
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
}
