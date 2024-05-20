return {
	"rmagatti/auto-session",
	config = function()
		require("auto-session").setup({
			auto_session_enable_last_session = vim.loop.cwd()
				== vim.loop.os_homedir(),
		})
	end,
}
