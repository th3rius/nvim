return {
  "echasnovski/mini.files",
  version = false,
  config = function()
    local bind = require("keybinder")
    local mini_files = require("mini.files")

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
          vim.api.nvim_buf_set_option(buf, "buftype", "acwrite")
          -- I don't think mini.files offers the current window
          -- directory through their api or anything elegant we can
          -- use as the buffer name here. as a hack we just use a
          -- ranodm number.
          vim.api.nvim_buf_set_name(ev.data.buf_id, tostring(math.random()))
          vim.api.nvim_create_autocmd("BufWriteCmd", {
            buffer = buf,
            callback = mini_files.synchronize,
          })

          -- We shouldn't use CoC completions here
          vim.b.coc_enabled = 0
          -- FIXME: since we have disabled CoC for the buffer,
          -- attempting to use complletions will cause an error.
          -- There's probably a more elegant solution for this.
          vim.api.nvim_buf_set_keymap(buf, "i", "<C-space>", "<Nop>", {})
        end)
      end,
    })

    local function toggle_mini_files()
      if not MiniFiles.close() then
        local buf = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
        MiniFiles.open(buf)
      end
    end

    bind.n("<leader>o", toggle_mini_files, "Toggle explorer")
  end,
}
