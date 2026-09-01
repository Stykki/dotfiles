-- Servers we care about. Configs come from nvim-lspconfig's `lsp/` dir,
-- merged with any local overrides in our own `lsp/` dir.
-- Each server is only enabled if its binary is on PATH (nice with nix
-- shells/profiles: whatever the environment provides just works).
--
-- Servers whose config `cmd` is a function (they resolve the binary from
-- node_modules/.bin at start time) can't be introspected, so we give the
-- fallback binary explicitly via `bin`. They're still enabled if the binary
-- exists locally in the project, because `root_dir`/`workspace_required`
-- gates them anyway -- so we also accept them when a project-local install
-- is plausible (node_modules check happens at start).
local servers = {
    "bashls",
    "elixirls",
    "eslint",
    "gopls",
    "lua_ls",
    "marksman",
    "rust_analyzer",
    "texlab",
    "wgsl_analyzer",
    "yamlls",
    "pyright",
    "zls",
    -- "helm_ls",
    -- Function-based cmd (project-local bin fallback handled by the config):
    { "oxc", bin = "oxlint", allow_local = true },
    { "oxfmt", bin = "oxfmt", allow_local = true },
    { "tsgo", bin = "tsgo", allow_local = true },
    { "tailwindcss", bin = "tailwindcss-language-server", allow_local = true },
}

for _, server in ipairs(servers) do
    local name, bin, allow_local
    if type(server) == "table" then
        name, bin, allow_local = server[1], server.bin, server.allow_local
    else
        name = server
        local cfg = vim.lsp.config[name]
        bin = cfg and type(cfg.cmd) == "table" and cfg.cmd[1] or nil
    end
    -- allow_local servers resolve node_modules/.bin per project at start
    -- time and are gated by root_dir, so enable them even without a global
    -- binary on PATH.
    if allow_local or (bin and vim.fn.executable(bin) == 1) then
        vim.lsp.enable(name)
    end
end

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
