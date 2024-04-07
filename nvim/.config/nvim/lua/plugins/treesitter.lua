return {
	"nvim-treesitter/nvim-treesitter",
	event = "VeryLazy",
	init = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "rust", "javascript", "typescript", "svelte", "css" },

			highlight = {
				enable = true,
			}

		})
	end,
}
