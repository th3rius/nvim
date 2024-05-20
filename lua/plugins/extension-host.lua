return {
	-- Nodejs extension host
	"neoclide/coc.nvim",
	dependencies = "rafamadriz/friendly-snippets", -- Adds a number of user-friendly snippets
	cond = function()
		return vim.fn.executable("node") == 1
	end,
	-- Install dependencies
	build = "npm ci",
	config = function()
		local bind = require("keybinder")
		local scroll_bind_opts = { silent = true, nowait = true, expr = true }
		local comp_bind_opts =
			{ silent = true, expr = true, replace_keycodes = false }

		-- don't override the built-in and fugitive keymaps
		local function bind_nv_fugitive_compat(lhs, rhs, desc)
			bind.nv(lhs, function()
				if not vim.wo.diff then
					return rhs
				end
				return "<Ignore>"
			end, desc, { expr = true })
		end

		local function show_docs()
			local cw = vim.fn.expand("<cword>")

			if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
				vim.api.nvim_command("h " .. cw)
			elseif vim.api.nvim_eval("coc#rpc#ready()") then
				vim.fn.CocActionAsync("doHover")
			else
				vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
			end
		end

		-- Make <Tab> to accept selected completion item
		bind.i(
			"<Tab>",
			[[coc#pum#visible() ? coc#pum#confirm() : "\<Tab>"]],
			comp_bind_opts
		)

		-- Use <C-space> to trigger completion
		bind.i("<C-space>", "coc#refresh()", comp_bind_opts)

		bind.n("<leader>r", "<Plug>(coc-rename)", "Rename")
		bind.n(
			"<leader>a",
			"<Plug>(coc-codeaction-selected)<CR>",
			"Code action"
		)

		bind.n("gd", "<Plug>(coc-definition)", "Goto definition")
		bind.n("gr", "<Plug>(coc-references)", "Goto references")
		bind.n("gI", "<Plug>(coc-implementation)", "Goto implementation")

		bind.n("K", show_docs, "Hover Documentation")

		-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
		vim.api.nvim_create_augroup("CocGroup", {})
		vim.api.nvim_create_autocmd("CursorHold", {
			group = "CocGroup",
			command = "silent call CocActionAsync('highlight')",
			desc = "Highlight symbol under cursor on CursorHold",
		})

		-- Update signature help on jump placeholder
		vim.api.nvim_create_autocmd("User", {
			group = "CocGroup",
			pattern = "CocJumpPlaceholder",
			command = "call CocActionAsync('showSignatureHelp')",
			desc = "Update signature help on jump placeholder",
		})

		-- Remap <C-f> and <C-b> to scroll float windows/popups
		bind.n(
			"<C-f>",
			'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"',
			scroll_bind_opts
		)
		bind.n(
			"<C-b>",
			'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"',
			scroll_bind_opts
		)
		bind.i(
			"<C-f>",
			'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"',
			scroll_bind_opts
		)
		bind.i(
			"<C-b>",
			'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"',
			scroll_bind_opts
		)
		bind.v(
			"<C-f>",
			'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"',
			scroll_bind_opts
		)
		bind.v(
			"<C-b>",
			'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"',
			scroll_bind_opts
		)

		bind_nv_fugitive_compat(
			"]c",
			"<Plug>(coc-git-nextchunk)",
			"Jump to next chunk"
		)
		bind_nv_fugitive_compat(
			"[c",
			"<Plug>(coc-git-prevchunk)",
			"Jump to previous chunk"
		)

		-- Diagnostic keymaps
		bind.n(
			"[d",
			"<Plug>(coc-diagnostic-prev)",
			"Go to previous diagnostic message"
		)
		bind.n(
			"]d",
			"<Plug>(coc-diagnostic-next)",
			"Go to next diagnostic message"
		)
		bind.n("<leader>q", ":CocList diagnostics<CR>", "Open diagnostics list")

		-- Format
		bind.n(
			"<leader>f",
			":sil! call CocAction('format')<CR>",
			"Format",
			{ silent = true }
		)
		bind.v(
			"<leader>f",
			":<C-u>sil! call CocAction('formatSelected', visualmode())<CR>",
			"Format",
			{ silent = true }
		)

		-- Lint
		bind.n(
			"<leader>l",
			":CocCommand eslint.executeAutofix<CR>",
			"Lint",
			{ silent = true }
		)
	end,
}
