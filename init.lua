-- Enables module cache
vim.loader.enable()

local bind = require("keybinder")

-- Use <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "git@github.com:folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
require("lazy").setup({
  -- git
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",

  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  -- Detach `updatetime` from the frequency of `CursorHold`
  "antoinemadec/FixCursorHold.nvim",

  -- editorconfig
  "editorconfig/editorconfig-vim",

  -- handy bracket mappings
  "tpope/vim-unimpaired",

  -- Delete/change/add parentheses/quotes/XML-tags/much more
  "tpope/vim-surround",

  -- Delete buffers and close files without closing
  -- windows or messing up the layout
  "th3rius/bufdelete.nvim",

  -- Auto pairs for brackets, parens, quotes
  { "windwp/nvim-autopairs", config = true },

  -- sticky buffers
  { "stevearc/stickybuf.nvim", config = true },

  -- Tab-scoped buffers
  { "tiagovla/scope.nvim", config = true },

  -- Adds git related signs to the gutter, as well as utilities for managing changes
  { "lewis6991/gitsigns.nvim", config = true },

  -- lua `fork` of vim-web-devicons for neovim
  { "nvim-tree/nvim-web-devicons", config = true },

  {
    -- slugbyte theme
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("onedark")
    end,
  },

  { import = "orion/plugins" },
}, {
  defaults = {
    git = {
      timeout = 1200,
      url_format = "git@github.com:%s.git",
    },
  },
})

-- [[ Setting options ]]
-- Set highlight on search
vim.o.hlsearch = false

-- Hybrid numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = "unnamedplus"

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Enables 24-bit RGB color
vim.o.termguicolors = true

-- Highlight column cursor
vim.o.cursorcolumn = true

-- Short cursorhold time
vim.g.cursorhold_updatetime = 100

-- Keep at least two lines above and below the cursor
vim.o.scrolloff = 2

-- lualine will show the mode for us
vim.o.showmode = false

-- Disable line wrapping. Makes it easier to work on smaller windows.
vim.o.wrap = false

-- [[ Persistent undo ]]
local undo_dir = vim.fn.expand("~/.cache/undodir")

if not vim.fn.isdirectory(undo_dir) then
  vim.fn.mkdir(undo_dir, "p", 0700)
end

vim.o.undodir = undo_dir
vim.o.undofile = true

-- [[ Basic Keymaps ]]
bind.nv("<leader>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
bind.n("k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
bind.n("j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Ergonomic buffer mappings
bind.ni("<C-s>", "<CMD>conf w<CR>", { silent = true })
bind.n("<C-c>", ":sil! conf Bdelete<CR>", { silent = true })
bind.n("<Tab>", ":sil! bn<CR>", { silent = true })
bind.n("<S-Tab>", ":sil! bp<CR>", { silent = true })

-- Tab navigation
bind.n("tn", ":tabnew<CR>", { silent = true })
bind.n("td", ":conf tabc<CR>", { silent = true })
bind.n("th", ":tabp<CR>", { silent = true })
bind.n("tl", ":tabn<CR>", { silent = true })

-- [[ Highlight on yank ]]
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = vim.api.nvim_create_augroup("orion-highlight-yank", { clear = true }),
  pattern = "*",
})
