-- the colorscheme should be available when starting Neovim
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		config = function()
			-- load the colorscheme here
			vim.cmd([[colorscheme catppuccin-mocha]])
		end,
	},
}
