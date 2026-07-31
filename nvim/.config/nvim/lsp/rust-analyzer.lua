---@type vim.lsp.Config
return {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        -- Prefer the cargo workspace root (handles workspace members correctly)
        local cargo_crate_dir = vim.fs.root(fname, { 'Cargo.toml' })
        if cargo_crate_dir then
            local out = vim.system({
                'cargo',
                'metadata',
                '--no-deps',
                '--format-version',
                '1',
            }, { cwd = cargo_crate_dir }):wait()
            if out.code == 0 then
                local ok, meta = pcall(vim.json.decode, out.stdout)
                if ok and meta and meta.workspace_root then
                    return on_dir(meta.workspace_root)
                end
            end
            return on_dir(cargo_crate_dir)
        end
        on_dir(vim.fs.root(fname, { 'rust-project.json', '.git' }))
    end,
    capabilities = {
        experimental = {
            serverStatusNotification = true,
        },
    },
    -- rust-analyzer reads its config from initializationOptions as well
    before_init = function(init_params, config)
        if config.settings and config.settings['rust-analyzer'] then
            init_params.initializationOptions = config.settings['rust-analyzer']
        end
    end,
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                allFeatures = true,
                buildScripts = { enable = true },
            },
            procMacro = { enable = true },
            -- Use clippy instead of plain `cargo check` for diagnostics
            checkOnSave = true,
            check = {
                command = 'clippy',
                extraArgs = { '--no-deps' },
            },
            imports = {
                granularity = { group = 'module' },
                prefix = 'self',
            },
            inlayHints = {
                bindingModeHints = { enable = false },
                chainingHints = { enable = true },
                closingBraceHints = { minLines = 25 },
                closureReturnTypeHints = { enable = 'never' },
                lifetimeElisionHints = { enable = 'never' },
                parameterHints = { enable = true },
                reborrowHints = { enable = 'never' },
                typeHints = { enable = true },
            },
            lens = { enable = true },
            files = {
                excludeDirs = { '.direnv', '.git', 'target', 'node_modules' },
            },
        },
    },
}
