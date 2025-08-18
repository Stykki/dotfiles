-- Define a command "FixPrTemplate" that can be invoked in Neovim
vim.api.nvim_create_user_command("FixPrTemplate", function(opts)
	-- Get the current branch name
	local branch_name = vim.fn.system("git branch --show-current"):gsub("%s+", "") -- Trim whitespace

	-- Extract the numeric Jira issue ID from the branch name (assuming the format is something like "feature/WEB-1234-description")
	local jira_issue_id = branch_name:match("WEB%-(%d+)") -- Extract the numeric part after "WEB-"

	-- If no Jira issue ID is found, prompt the user for it manually
	if not jira_issue_id then
		jira_issue_id = vim.fn.input("Enter Jira Issue ID (just the number): ")
		if jira_issue_id == "" then
			print("No Jira Issue ID provided.")
			return
		end
	end

	-- Read the contents of the current buffer
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	-- Prepare a new set of lines with the modifications
	local new_lines = {}
	local last_line_empty = false

	for _, line in ipairs(lines) do
		-- Skip lines that start with ">"
		if line:match("^>") then
			goto continue
		end

		-- Skip sections after "Remove this section"
		if line:find("Remove this section") then
			break
		end

		-- Replace placeholders with the Jira issue ID
		line = line:gsub("WEB%-", "WEB-" .. jira_issue_id)
		line = line:gsub("/web", "/web" .. jira_issue_id)

		-- Ensure no consecutive newlines
		if line:match("^%s*$") then -- Check if the line is empty or just whitespace
			if last_line_empty then
				goto continue
			else
				last_line_empty = true
			end
		else
			last_line_empty = false
		end

		-- Add the line to the new buffer
		table.insert(new_lines, line)

		::continue::
	end

	-- Replace the buffer's content with the new lines
	vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)

	print("Pull Request template updated successfully with Jira ID: WEB-" .. jira_issue_id)
end, { nargs = 0, desc = "Update App Pull Request Template" })

return
