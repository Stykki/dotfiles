return {
	{
		'numToStr/Comment.nvim',

		config = function() require("Comment").setup() end,

		keys = {
			{ "gcc", mode = "n" },
			{ "gc",  mode = "v" },
			{ "gbc", mode = "n" },
			{ "gb",  mode = "v" },
			{
				"<leader>/",
				function()
					require("Comment.api").toggle.linewise.current()
				end,
				desc = "Toggle current line",
				mode = "n"
			},

			{
				"<leader>/",
				"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
				desc = "Toggle comment",
				mode = "v"
			},

			{
				"<leader>cb",
				'<ESC><CMD>lua require("Comment.api").locked("toggle.blockwise")(vim.fn.visualmode())<CR>',
				desc = "Toggle blockwize",
				mode = "v"
			}
		},

		lazy = false,
	}
}
