return {
	-- Manage multiple terminal windows
	"akinsho/toggleterm.nvim",
	config = function()
		local bind = require("keybinder")
		local toggleterm = require("toggleterm")

		toggleterm.setup()

		vim.cmd(
			"autocmd! TermOpen term://*toggleterm#* lua SetTerminalKeymaps()"
		)

		function SetTerminalKeymaps()
			local opts = { buffer = 0 }
			-- Add mappings to make moving in and out of a terminal
			-- easier once toggled, whilst still keeping it open.
			bind.t("<esc>", [[<C-\><C-n>]], opts)
			bind.t("<C-w>", [[<C-\><C-n><C-w>]], opts)
		end

		bind.nt("<leader>\\", '<CMD>exe v:count . "ToggleTerm"<CR>', {
			desc = "Toggle terminal",
			silent = true,
		})
	end,
}
