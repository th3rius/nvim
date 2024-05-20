return {
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
}
