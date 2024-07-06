return { -- Autoformat
  "stevearc/conform.nvim",
  lazy = false,
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
    },
  },
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "eslint_d", "prettierd" },
      javascriptreact = { "eslint_d", "prettierd" },
      typescript = { "eslint_d", "prettierd" },
      typescriptreact = { "eslint_d", "prettierd" },
    },
  },
}
