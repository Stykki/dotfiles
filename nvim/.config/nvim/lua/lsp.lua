vim.lsp.enable({
    "bashls",
    "eslint",
    "gopls",
    "lua_ls",
    "oxc",
    "oxfmt",
    "rust-analyzer",
    "texlab",
    "tsgo",
    "wgsl-analyzer",
    "yamlls",
    "pyright",
    "zls",
    -- "helm_ls",
})

vim.diagnostic.config({ signs = true })

-- Inlay hints (rust-analyzer & co.), toggle with <leader>uh
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspInlayHints", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end
    end,
})
