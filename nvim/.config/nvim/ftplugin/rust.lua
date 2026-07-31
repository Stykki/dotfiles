-- Rust buffer-local setup

-- `:make build|run|test|clippy` with cargo errorformat -> quickfix
vim.cmd.compiler("cargo")

vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.textwidth = 100

local function cargo(args)
    return function()
        vim.cmd("silent! write")
        vim.cmd("make " .. args)
        vim.cmd("copen")
    end
end

local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = true, silent = true, desc = desc })
end

map("<leader>rb", cargo("build"), "Cargo build")
map("<leader>rr", cargo("run"), "Cargo run")
map("<leader>rt", cargo("test"), "Cargo test")
map("<leader>rc", cargo("clippy --all-targets --all-features"), "Cargo clippy")
map("<leader>rk", cargo("check"), "Cargo check")
map("<leader>rd", "<cmd>!cargo doc --open<CR>", "Cargo doc (open)")

-- rust-analyzer specific LSP extras
map("<leader>rm", function()
    vim.lsp.buf.code_action({ context = { only = { "refactor.rewrite" } } })
end, "Rust refactor actions")

map("<leader>re", function()
    local client = vim.lsp.get_clients({ bufnr = 0, name = "rust-analyzer" })[1]
    if not client then
        return vim.notify("rust-analyzer not attached", vim.log.levels.WARN)
    end
    client:request("rust-analyzer/expandMacro", vim.lsp.util.make_position_params(0, client.offset_encoding),
        function(err, result)
            if err or not result then
                return vim.notify("No macro under cursor", vim.log.levels.INFO)
            end
            local lines = vim.split(result.expansion, "\n", { plain = true })
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
            vim.bo[buf].filetype = "rust"
            vim.api.nvim_open_win(buf, true, {
                relative = "editor",
                width = math.floor(vim.o.columns * 0.8),
                height = math.floor(vim.o.lines * 0.6),
                row = math.floor(vim.o.lines * 0.15),
                col = math.floor(vim.o.columns * 0.1),
                border = "rounded",
                title = " " .. (result.name or "macro") .. " ",
            })
        end, 0)
end, "Expand macro")
