vim.lsp.enable({
    "bashls",
    "eslint",
    "gopls",
    "lua_ls",
    "oxc",
    "oxfmt",
    "rust-analyzer",
    "texlab",
    "ts_ls",
    "yamlls",
    "pyright",
    "zls",
    -- "helm_ls",
})

-- Register tsgo but keep it disabled by default (toggle with :ToggleTsGo)
vim.lsp.enable("tsgo", false)

vim.diagnostic.config({ signs = true })
