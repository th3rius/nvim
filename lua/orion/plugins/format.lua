local bind = require("keybinder")

-- Autoformat
return {
  "stevearc/conform.nvim",
  config = function()
    local conform = require("conform")

    conform.setup({
      notify_on_error = false,
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "eslint_d", "prettierd" },
        javascriptreact = { "eslint_d", "prettierd" },
        typescript = { "eslint_d", "prettierd" },
        typescriptreact = { "eslint_d", "prettierd" },
        ["*"] = { "trim_newlines", "prettierd" },
      },
    })

    bind.nv("<leader>f", function()
      conform.format({ async = true, lsp_format = "fallback" })
    end, "Format")
  end,
}
