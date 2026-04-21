local vite_markers = {
    "vite.config.ts",
    "vite.config.js",
    "vite.config.mts",
    "vite.config.mjs",
}

---@type vim.lsp.Config
return {
    cmd = function(dispatchers, config)
        local cmd = "oxlint"
        if (config or {}).root_dir then
            local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
            if vim.fn.executable(local_cmd) == 1 then
                cmd = local_cmd
            end
        end
        return vim.lsp.rpc.start({ cmd, "--lsp" }, dispatchers)
    end,
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
    root_dir = function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, vite_markers)
        if root then
            on_dir(root)
        end
    end,
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, "LspOxlintFixAll", function()
            client:exec_cmd({
                title = "Apply Oxlint automatic fixes",
                command = "oxc.fixAll",
                arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
            })
        end, { desc = "Apply Oxlint automatic fixes" })
    end,
    before_init = function(init_params, config)
        init_params.initializationOptions = {
            settings = config.settings or {},
        }
    end,
}
