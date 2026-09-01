local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local map = vim.keymap.set
local bs = { buffer = true, silent = true }
local brs = { buffer = true, remap = true, silent = true }

-- Enable treesitter highlighting (Neovim provides it; nvim-treesitter only
-- ships the parsers + queries). Injections work automatically once started.
autocmd("FileType", {
    pattern = "*",
    callback = function(ev)
        local dominated_filetypes = { "netrw", "qf", "help", "checkhealth" }
        if vim.tbl_contains(dominated_filetypes, vim.bo[ev.buf].filetype) then
            return
        end
        -- Only start if a parser exists for this filetype
        local ok = pcall(vim.treesitter.start, ev.buf)
        if not ok then
            -- No parser available, that's fine
            return
        end
        -- Experimental treesitter indentation (opt-in, note the quoting):
        -- vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
    group = augroup("TreesitterHighlight", { clear = true }),
})

-- Highlight yanked text
local highlight_group = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ timeout = 170 })
    end,
    group = highlight_group,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        map("n", "<C-c>", "<cmd>bd<CR>", bs)
        map("n", "<Tab>", "mf", brs)
        map("n", "<S-Tab>", "mF", brs)
        map("n", "%", function()
            local dir = vim.b.netrw_curdir or vim.fn.expand("%:p:h")
            vim.ui.input({ prompt = "Enter filename: " }, function(input)
                if input and input ~= "" then
                    local filepath = dir .. "/" .. input
                    vim.cmd("!touch " .. vim.fn.shellescape(filepath))
                    vim.api.nvim_feedkeys("<C-l>", "n", false)
                end
            end)
        end, bs)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(ev)
        local ft = vim.bo[ev.buf].filetype
        local formatting = "lua vim.lsp.buf.format()"

        if ft == "lua" then
            formatting = "!stylua %"
        elseif ft == "tex" then
            formatting = "!latexindent -s -l -w %"
        elseif ft == "python" then
            formatting = "!black %"
        end

        local cmd = function()
            vim.cmd("write")
            vim.cmd("silent " .. formatting)
        end

        map("n", "<leader>fo", cmd, { buffer = ev.buf })
    end,
})
