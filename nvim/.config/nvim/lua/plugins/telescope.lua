return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.6',
	lazy = false,
	dependencies = { 'nvim-lua/plenary.nvim' },
	keys = {
		-- add a keymap to browse plugin files
		-- stylua: ignore
		-- TODO: add more mappings https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#pickers
		{
			"<leader>fp",
			function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
			desc = "Find Plugin File",
		},

		{
			"<leader>ff",
			function() require("telescope.builtin").find_files() end,
			desc = "Telescope find files",
		},
		{
			"<leader>fw",
			function() require("telescope.builtin").find_files() end,
			desc = "Telescope find word",
		},
		{
			"<leader>fb",
			function() require("telescope.builtin").buffers() end,
			desc = "Telescope buffers",
		},
		{
			"<leader>gt",
			function() require("telescope.builtin").git_files() end,
			desc = "Telescope git changes",
		}
	},


}
