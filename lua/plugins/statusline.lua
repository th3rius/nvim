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
				lualine_x = {
					{ "fileformat", padding = { right = 2, left = 1 } },
				},
			},
		})
	end,
}
