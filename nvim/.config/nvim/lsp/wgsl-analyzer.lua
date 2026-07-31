---@type vim.lsp.Config
return {
    cmd = { 'wgsl-analyzer' },
    filetypes = { 'wgsl' },
    root_markers = {
        'wgsl-analyzer.toml',
        '.wgsl-analyzer.toml',
        'Cargo.toml',
        '.git',
    },
    -- Fall back to the file's own directory so single shaders still work
    root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        on_dir(
            vim.fs.root(fname, {
                'wgsl-analyzer.toml',
                '.wgsl-analyzer.toml',
                'Cargo.toml',
                '.git',
            }) or vim.fs.dirname(fname)
        )
    end,
    -- wgsl-analyzer (like rust-analyzer) reads config from initializationOptions
    before_init = function(init_params, config)
        if config.settings and config.settings['wgsl-analyzer'] then
            init_params.initializationOptions = config.settings['wgsl-analyzer']
        end
    end,
    settings = {
        ['wgsl-analyzer'] = {
            diagnostics = {
                typeErrors = true,
                nagaParsingErrors = true,
                nagaValidationErrors = true,
            },
            inlayHints = {
                enabled = true,
                typeHints = true,
                parameterHints = true,
                structLayoutHints = true,
                typeVerbosity = 'compact',
                renderColons = true,
            },
            -- Preprocessor-ish imports used by engines like Bevy
            customImports = {},
            shaderDefs = {},
        },
    },
}
