local bind = require("keybinder")

return {
  "echasnovski/mini.files",
  version = false,
  config = function()
    local mini_files = require("mini.files")
    local cmp = require("cmp")

    mini_files.setup({
      options = {
        permanent_delete = false,
      },

      mappings = {
        go_in_plus = "",
        go_out_plus = "",
        go_in = "L",
        go_out = "H",
      },

      content = {
        filter = function(entry)
          return entry.name ~= ".git" and entry.name ~= "node_modules"
        end,
      },
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(ev)
        vim.schedule(function()
          local buf = ev.data.buf_id

          local go_in_plus =
            ":lua MiniFiles.go_in({ close_on_file = true })<CR>"
          local go_out_plus =
            ":lua MiniFiles.go_out(); MiniFiles.trim_right()<CR>"

          local function buf_bind_n(lhs, rhs)
            vim.api.nvim_buf_set_keymap(buf, "n", lhs, rhs, { silent = true })
          end

          buf_bind_n("<esc>", ":lua MiniFiles.close()<CR>")
          buf_bind_n("<CR>", go_in_plus)
          buf_bind_n("<Tab>", go_in_plus)
          buf_bind_n("<S-Tab>", go_out_plus)
          buf_bind_n("<C-c>", ":lua MiniFiles.close()<CR>")

          -- enables synchronizing with :w. this allows
          -- reusing bindings that call :w.
          vim.api.nvim_set_option_value("buftype", "acwrite", { buf = buf })

          -- mini.files doesn't offers the current window
          -- directory through their API or anything elegant we can
          -- use as the buffer name here. as a hack we just use a
          -- ranodm number.
          vim.api.nvim_buf_set_name(ev.data.buf_id, tostring(math.random()))
          vim.api.nvim_create_autocmd("BufWriteCmd", {
            buffer = buf,
            callback = mini_files.synchronize,
          })

          -- Disable completions here.
          cmp.setup.buffer({ enabled = false })
        end)
      end,
    })

    local function toggle_mini_files()
      if not MiniFiles.close() then
        local buf = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
        -- Check if the buffer is something that exists on disk (e.g. not a terminal).
        -- If it is not, open the current working directory.
        local openable = vim.fn.getftype(buf) ~= ""
        MiniFiles.open(openable and buf or nil)
      end
    end

    bind.n("<leader>o", toggle_mini_files, "Toggle explorer")
  end,
}
