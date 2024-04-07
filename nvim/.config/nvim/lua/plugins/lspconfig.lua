return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.rust_analyzer.setup {
				capabilities = vim.lsp.protocol.make_client_capabilities()
			}

			lspconfig.lua_ls.setup {
				capabilities = vim.lsp.protocol.make_client_capabilities()
			}

			lspconfig.svelte.setup {
				capabilities = vim.lsp.protocol.make_client_capabilities()
			}

			lspconfig.tsserver.setup {
				capabilities = vim.lsp.protocol.make_client_capabilities()
			}


			lspconfig.css_variables.setup {
				capabilities = vim.lsp.protocol.make_client_capabilities()
			}
		end,
	},
}
