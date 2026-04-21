local eslint_markers = {
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json",
    "eslint.config.js",
    "eslint.config.mjs",
    "eslint.config.cjs",
    "eslint.config.ts",
    "eslint.config.mts",
    "eslint.config.cts",
}

local vite_markers = {
    "vite.config.ts",
    "vite.config.js",
    "vite.config.mts",
    "vite.config.mjs",
}

---@type vim.lsp.Config
return {
    cmd = { "vscode-eslint-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
    root_dir = function(bufnr, on_dir)
        -- Skip ESLint in Vite projects (oxlint handles those)
        if vim.fs.root(bufnr, vite_markers) then
            return
        end
        local root = vim.fs.root(bufnr, eslint_markers)
        if root then
            on_dir(root)
        end
    end,
    settings = {
        validate = "on",
        packageManager = nil,
        useESLintClass = false,
        experimental = { useFlatConfig = false },
        codeActionOnSave = { enable = false, mode = "all" },
        format = false,
        quiet = false,
        onIgnoredFiles = "off",
        rulesCustomizations = {},
        run = "onType",
        problems = { shortenToSingleLine = false },
        nodePath = "",
        workingDirectory = { mode = "location" },
        codeAction = {
            disableRuleComment = {
                enable = true,
                location = "separateLine",
            },
            showDocumentation = { enable = true },
        },
    },
}
