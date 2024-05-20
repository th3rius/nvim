return {
	-- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		{
			-- Use treesitter to autoclose and autorename html tag
			"windwp/nvim-ts-autotag",
			opts = {},
		},
		{
			-- "gc" to comment visual regions/lines
			"numToStr/Comment.nvim",
			dependencies = {
				"JoosepAlviste/nvim-ts-context-commentstring",
			},
			config = function()
				require("Comment").setup({
					pre_hook = require(
						"ts_context_commentstring.integrations.comment_nvim"
					).create_pre_hook(),
				})
			end,
		},
	},
	build = ":TSUpdate",
	config = function()
		-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
		vim.defer_fn(function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"tsx",
					"javascript",
					"typescript",
					"vim",
					"bash",
				},

				auto_install = true,

				cotext_commentstring = {
					enable = true,
					enable_autocmd = false,
				},
				highlight = { enable = true },
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<c-space>",
						node_incremental = "<c-space>",
						scope_incremental = "<c-s>",
						node_decremental = "<M-space>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
					},
					swap = {
						enable = true,
					},
				},
			})
		end, 0)
	end,
}
