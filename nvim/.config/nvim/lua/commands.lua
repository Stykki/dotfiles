-- OpenBranchFiles: Open all files modified in current branch vs main
vim.api.nvim_create_user_command("OpenBranchFiles", function()
    -- Detect the default branch (e.g., origin/main or origin/master)
    local branch_handle = io.popen("git rev-parse --abbrev-ref origin/HEAD 2>/dev/null")
    local remote_head = branch_handle and branch_handle:read("*l") or ""
    if branch_handle then branch_handle:close() end

    local main_branch = "main"
    if remote_head and remote_head ~= "" then
        main_branch = remote_head:gsub("origin/", "")
    end

    -- Get the list of modified files
    local cmd = string.format("git diff --name-only %s...", main_branch)
    local file_handle = io.popen(cmd)
    if not file_handle then
        vim.notify("Failed to get branch files", vim.log.levels.ERROR)
        return
    end

    local files_opened = 0
    for file in file_handle:read("*a"):gmatch("[^\r\n]+") do
        -- Only open if the file actually exists (skip deleted files)
        if vim.fn.filereadable(file) == 1 then
            vim.cmd("badd " .. vim.fn.fnameescape(file))
            files_opened = files_opened + 1
        end
    end
    file_handle:close()

    -- Feedback for the user
    if files_opened > 0 then
        vim.notify(string.format("Opened %d files from branch vs %s", files_opened, main_branch), vim.log.levels.INFO)
    else
        vim.notify("No modified files to open", vim.log.levels.INFO)
    end
end, {
    desc = "Open all files modified in the current branch",
})
