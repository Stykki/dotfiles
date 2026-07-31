local keymap = vim.keymap.set

-- Disable space in normal mode (reserved for leader)
keymap("n", "<space>", "<Nop>", { desc = "Disable space (leader key)" })

-- Semicolon as colon (enter command mode)
keymap("n", ";", ":", { desc = "Command mode" })

-- Movement
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Move down (visual line)" })
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Move up (visual line)" })
keymap("n", "<C-d>", "<C-d>zz", { desc = "Half page down and center" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Half page up and center" })

-- Save and quit
keymap("n", "<Leader>w", "<cmd>w!<CR>", { silent = true, desc = "Save file" })
keymap("n", "<Leader>q", "<cmd>q<CR>", { silent = true, desc = "Quit" })

-- Tabs
keymap("n", "<Leader>te", "<cmd>tabnew<CR>", { silent = true, desc = "New tab" })
keymap("n", "<Leader>tn", "<cmd>tabn<CR>", { silent = true, desc = "Next tab" })
keymap("n", "<Leader>tp", "<cmd>tabp<CR>", { silent = true, desc = "Previous tab" })

-- Split windows
keymap("n", "<Leader>_", "<cmd>vsplit<CR>", { silent = true, desc = "Vertical split" })
keymap("n", "<Leader>-", "<cmd>split<CR>", { silent = true, desc = "Horizontal split" })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { silent = true, desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { silent = true, desc = "Move to window below" })
keymap("n", "<C-k>", "<C-w>k", { silent = true, desc = "Move to window above" })
keymap("n", "<C-l>", "<C-w>l", { silent = true, desc = "Move to right window" })

-- Copy and paste
keymap("v", "<Leader>p", '"_dP', { desc = "Paste without yanking replaced text" })

-- Terminal
keymap("t", "<Esc>", "<C-\\><C-N>", { desc = "Exit terminal mode" })

-- Directory navigation
keymap("n", "<leader>cd", '<cmd>lua vim.fn.chdir(vim.fn.expand("%:p:h"))<CR>', { desc = "Change to file's directory" })

-- LSP
keymap("n", "grd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true, desc = "Go to definition" })
keymap("n", "<leader>.", vim.lsp.buf.code_action, { desc = "Code actions" })
keymap({ "n", "v" }, "<leader>fm", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

-- Diagnostics
keymap("n", "<leader>dk", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
keymap("n", "<leader>dn", "<cmd>lua vim.diagnostic.jump({count = 1})<CR>", { noremap = true, silent = true, desc = "Next diagnostic" })
keymap("n", "<leader>dp", "<cmd>lua vim.diagnostic.jump({count = -1})<CR>", { noremap = true, silent = true, desc = "Previous diagnostic" })
keymap("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })
keymap("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Previous diagnostic" })

-- File explorers
keymap("n", "<leader>of", "<cmd>Oil<CR>", { desc = "Open Oil at file's directory" })
keymap("n", "<leader>oc", function() require("oil").open(vim.fn.getcwd()) end, { desc = "Open Oil at cwd" })

-- Plugin management
keymap("n", "<leader>ps", "<cmd>lua vim.pack.update()<CR>", { desc = "Update plugins" })

-- Git
keymap("n", "<leader>gs", "<cmd>Git<CR>", { noremap = true, silent = true, desc = "Git status (Fugitive)" })
keymap("n", "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Open in browser (GitHub/GitLab)" })

-- Snacks picker (primary search)
keymap("n", "<leader>sf", function() Snacks.picker.files() end, { desc = "Search files" })
keymap("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Search by grep" })
keymap("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Search help tags" })
keymap("n", "<leader>sb", function() Snacks.picker.buffers() end, { desc = "Search buffers" })
keymap("n", "<leader>sr", function() Snacks.picker.recent() end, { desc = "Search recent files" })
keymap("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Search diagnostics" })
keymap("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Search keymaps" })
keymap("n", "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Search word under cursor" })
keymap("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep in project" })
keymap("n", "<leader><leader>", function() Snacks.picker.smart() end, { desc = "Smart find (files + recent)" })

-- Git search
keymap("n", "<leader>sG", function() Snacks.picker.git_status() end, { desc = "Search git status" })
keymap("n", "<leader>st", function() Snacks.picker.git_status() end, { desc = "Search git modified files" })
keymap("n", "<leader>sc", function() Snacks.picker.git_log() end, { desc = "Search git commits" })
keymap("n", "<leader>sB", function()
    -- Get main branch name
    local handle = io.popen("git rev-parse --abbrev-ref origin/HEAD 2>/dev/null")
    local remote_head = handle and handle:read("*l") or ""
    if handle then handle:close() end
    local main_branch = "main"
    if remote_head and remote_head ~= "" then
        main_branch = remote_head:gsub("origin/", "")
    end
    -- Use fzf-lua to search files changed in branch
    require("fzf-lua").fzf_exec(string.format("git diff --name-only %s...", main_branch), {
        prompt = "Branch Files> ",
        previewer = "builtin",
        actions = {
            ["default"] = require("fzf-lua.actions").file_edit_or_qf,
            ["ctrl-q"] = require("fzf-lua.actions").file_sel_to_qf,
        },
    })
end, { desc = "Search branch changes (vs main)" })

-- Snacks UI
keymap("n", "<leader>un", function() Snacks.notifier.hide() end, { desc = "Dismiss all notifications" })
keymap("n", "<leader>uh", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "Toggle inlay hints" })

-- fzf-lua (secondary search)
keymap("n", "<leader>Ff", "<cmd>FzfLua files<CR>", { desc = "Find files (fzf)" })
keymap("n", "<leader>Fg", "<cmd>FzfLua grep_project<CR>", { desc = "Grep project (fzf)" })
keymap("n", "<leader>Fl", "<cmd>FzfLua grep_last<CR>", { desc = "Repeat last grep (fzf)" })
keymap("n", "<leader>Fh", "<cmd>FzfLua help_tags<CR>", { desc = "Help tags (fzf)" })

-- Command runner
keymap("n", "<leader>co", "<cmd>CommandExecute<CR>", { desc = "Execute command" })
keymap("n", "<leader>cr", "<cmd>CommandExecuteLast<CR>", { desc = "Execute last command" })
keymap({"x", "v"}, "<leader>co", "<cmd>CommandExecuteSelection<CR>", { desc = "Execute selection as command" })

-- Copilot suggestions now appear in blink.cmp popup
-- Accept with <C-n> (select_and_accept) or navigate with <C-j>/<C-k>

-- Special utilities
keymap("n", "<leader>ip", function()
    require("fzf-lua").files({
        actions = {
            ["default"] = function(selected)
                local file = selected[1]
                local rel_path = vim.fn.fnamemodify(file, ":.")
                rel_path = rel_path:gsub(" ", "\\ ")
                if not rel_path:match("^%.?/") then
                    rel_path = "./" .. rel_path
                end
                vim.api.nvim_put({ rel_path }, "l", true, false)
            end,
        },
    })
end, { desc = "Insert relative file path" })
