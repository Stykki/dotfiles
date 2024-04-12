local mappings = {
	i = {
		-- go to  beginning and end
		["<C-b>"] = { "<ESC>^i", "Beginning of line" },
		["<C-e>"] = { "<End>", "End of line" },

		-- navigate within insert mode
		["<C-h>"] = { "<Left>", "Move left" },
		["<C-l>"] = { "<Right>", "Move right" },
		["<C-j>"] = { "<Down>", "Move down" },
		["<C-k>"] = { "<Up>", "Move up" },
	},

	n = {
		["<Esc>"] = { ":noh <CR>", "Clear highlights" },
		-- switch between windows
		["<C-h>"] = { "<C-w>h", "Window left" },
		["<C-l>"] = { "<C-w>l", "Window right" },
		["<C-j>"] = { "<C-w>j", "Window down" },
		["<C-k>"] = { "<C-w>k", "Window up" },

		-- save
		["<C-s>"] = { "<cmd> w <CR>", "Save file" },

		-- Copy all
		["<C-c>"] = { "<cmd> %y+ <CR>", "Copy whole file" },

		-- line numbers
		["<leader>n"] = { "<cmd> set nu! <CR>", "Toggle line number" },
		["<leader>rn"] = { "<cmd> set rnu! <CR>", "Toggle relative number" },

		-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
		-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
		-- empty mode is same as using <cmd> :map
		-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
		["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
		["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
		["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
		-- new buffer
		["<leader>b"] = { "<cmd> enew <CR>", "New buffer" },
		["<leader>ch"] = { "<cmd> NvCheatsheet <CR>", "Mapping cheatsheet" },
		-- Lsp
		["<leader>k"] = {
			function()
				vim.diagnostic.open_float { border = "rounded" }
			end,
			"Floating diagnostic",
		},

		["[d"] = {
			function()
				vim.diagnostic.goto_prev({ float = { border = "rounded" } })
			end,
			"Goto prev",
		},

		["]d"] = {
			function()
				vim.diagnostic.goto_next({ float = { border = "rounded" } })
			end,
			"Goto next",
		},

		["<leader>q"] = {
			function()
				vim.diagnostic.setloclist()
			end,
			"Diagnostic setloclist",
		},

		["<leader>fm"] = {
			function()
				vim.lsp.buf.format { async = true }
			end,
			"LSP formatting",
		},

		["gD"] = {
			function()
				vim.lsp.buf.declaration()
			end,
			"LSP declaration",
		},

		["gd"] = {
			function()
				vim.lsp.buf.definition()
			end,
			"LSP definition",
		},
		["gr"] = {
			function()
				vim.lsp.buf.references()
			end,
			"LSP references",
		},

		["<leader>."] = {
			function()
				vim.lsp.buf.references()
				vim.lsp.buf.code_action()
			end,
			"Lsp code action",
		},

		-- Telescope
		-- ["<leader>ff"] = {
		--	telescope.find_files,
		--	"Telescope find files"
		-- }

	},

	t = {
		["<C-x>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "Escape terminal mode" },
		-- Navigate in and out out terminal windows with ctrl + vim motion
		["<C-h>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N><C-w>h", true, true, true) },
		["<C-j>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N><C-w>j", true, true, true) },
		["<C-k>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N><C-w>k", true, true, true) },
		["<C-l>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N><C-w>l", true, true, true) },
	},

	x = {
		-- Don't copy the replaced text after pasting in visual mode
		-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
		["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', "Dont copy replaced text", opts = { silent = true } },
	},
}

-- Register mappings
vim.schedule(function()
	for mode, mode_values in pairs(mappings) do
		for keybind, mapping_info in pairs(mode_values) do
			local opts = {}
			if mapping_info.opts then
				opts = mapping_info.opts
			end
			opts.desc = mapping_info[2]
			vim.keymap.set(mode, keybind, mapping_info[1], opts)
		end
	end
end)
