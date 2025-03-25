-- Create a buffer-local command that takes a shell command,
-- processes it with your sed transformation, and populates the quickfix list
vim.api.nvim_buf_create_user_command(0, "UpdateAppPrTemplate", function(opts)

	-- Get current branch name
	local output = vim.fn.system("git branch --show-current")

	vim.

end, { nargs = "+", desc = "Update App Pull Request Template" })


return 
