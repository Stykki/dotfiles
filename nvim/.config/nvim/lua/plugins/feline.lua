return {
	{
		'freddiehaddad/feline.nvim',
		opts = {},
		config = function(_, opts)
			-- Set catppuccin theme
			local ctp_feline = require('catppuccin.groups.integrations.feline')
			require("feline").setup({
				components = ctp_feline.get()
			})

		end
	}
}
