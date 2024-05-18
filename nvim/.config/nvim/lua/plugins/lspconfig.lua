local capabilities = require('cmp_nvim_lsp').default_capabilities()

return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.rust_analyzer.setup {
				capabilities = vim.lsp.protocol.make_client_capabilities(),
				filetypes = { "rust" },
				settings = {
					['rust-analyzer'] = {
						cargo = {
							allFeatures = true
						}
					}
				}
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


			lspconfig.tailwindcss.setup {
				capabilities = vim.lsp.protocol.make_client_capabilities()
			}

			lspconfig.zls.setup {
				capabilities = vim.lsp.protocol.make_client_capabilities()
			}

		lspconfig.openscad_lsp.setup {
				capabilities = capabilities
			}

		end,
	},
}
