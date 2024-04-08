return {
	"nvimtools/none-ls.nvim",

	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	config = function()
		local null_ls = require("null-ls")

		local formatting = null_ls.builtins.formatting
		local lint = null_ls.builtins.diagnostics
		local sources = {
			formatting.prettierd.with({
				extra_filetypes = { "markdown", "json", "html" },
			})
		}

		null_ls.setup {
			debug = true,
			sources = sources,
		}
	end,

}
