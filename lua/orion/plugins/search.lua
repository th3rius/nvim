local bind = require("keybinder")

return {
  -- Fuzzy Finder (files, lsp, etc)
  "nvim-telescope/telescope.nvim",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    local sorters = require("telescope.sorters")
    local action_state = require("telescope.actions.state")
    local bufdelete = require("bufdelete").bufdelete

    local delete_buffer = function(bufnr)
      local current_picker = action_state.get_current_picker(bufnr)
      current_picker:delete_selection(function(selection)
        return pcall(bufdelete, selection.bufnr)
      end)
    end

    telescope.setup({
      defaults = {
        file_sorter = sorters.get_levenshtein_sorter(),
        file_ignore_patterns = { "^%.git/", "^node_modules/" },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        live_grep = {
          file_ignore_patterns = {
            "%.lock$",
            "^package%-lock%.json$",
          },
        },
        buffers = {
          mappings = {
            n = {
              ["<C-c>"] = delete_buffer,
            },
          },
        },
      },
    })

    -- Enable telescope fzf native, if installed
    pcall(telescope.load_extension, "fzf")

    bind.n("<leader><leader>", builtin.buffers, "Find buffers")
    bind.n("<leader>/", builtin.find_files, "Find files")
    bind.n("<leader>;", builtin.live_grep, "Live grep")
    bind.n("<leader>?", builtin.resume, "Resume search")
  end,
}
