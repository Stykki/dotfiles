-- Create a buffer-local command that takes a shell command,
-- processes it with your sed transformation, and populates the quickfix list
vim.api.nvim_buf_create_user_command(0, "QuickfixCommand", function(opts)
	-- Get the command from arguments
	local cmd = opts.args

	-- Run the command with the transformation
	local output = vim.fn.system(cmd .. " | sed 's/(\\(.*\\),\\(.*\\)):/:\\1:\\2:/'")

	-- Split the output into lines
	local lines = vim.split(output, "\n")

	-- Create quickfix items
	local qf_items = {}
	for _, line in ipairs(lines) do
		-- Skip empty lines
		if line ~= "" then
			-- Parse line into filename, lnum, col, text parts
			local filename, lnum, col, text = line:match("([^:]+):(%d+):(%d+):(.*)")

			if filename and lnum and col then
				table.insert(qf_items, {
					filename = filename,
					lnum = tonumber(lnum),
					col = tonumber(col),
					text = text or "",
				})
			else
				-- For lines that don't match the expected pattern, just add as text
				table.insert(qf_items, { text = line })
			end
		end
	end

	-- Populate the quickfix list
	vim.fn.setqflist(qf_items, "r")

	-- Open the quickfix window
	vim.cmd("copen")
end, { nargs = "+", desc = "Transform command output and send to quickfix list" })


return 
