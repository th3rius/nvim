return {
  -- Set lualine as statusline
  "nvim-lualine/lualine.nvim",
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
}
