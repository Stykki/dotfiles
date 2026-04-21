---@type vim.lsp.Config
return {
    cmd = function(dispatchers, config)
        local cmd = "oxfmt"
        if (config or {}).root_dir then
            local local_cmd =
                vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
            if vim.fn.executable(local_cmd) == 1 then
                cmd = local_cmd
            end
        end
        return vim.lsp.rpc.start({ cmd, "--lsp" }, dispatchers)
    end,
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "toml",
        "json",
        "jsonc",
        "json5",
        "yaml",
        "html",
        "vue",
        "handlebars",
        "css",
        "scss",
        "less",
        "graphql",
        "markdown",
    },
    workspace_required = true,
    root_dir = function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, {
            ".oxfmtrc.json",
            ".oxfmtrc.jsonc",
            "oxfmt.config.ts",
            "vite.config.ts",
        })
        if root then
            return on_dir(root)
        end

        -- Fallback: check if package.json contains "oxfmt"
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local pkg =
            vim.fs.find("package.json", { path = fname, upward = true })[1]
        if pkg then
            local f = io.open(pkg, "r")
            if f then
                local content = f:read("*a")
                f:close()
                if content:find("oxfmt") then
                    on_dir(vim.fs.dirname(pkg))
                end
            end
        end
    end,
}
