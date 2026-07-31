local HOME = vim.fn.expand("~")
local local_dev = "file://" .. HOME
vim.pack.add({
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    {
        src = "https://github.com/saghen/blink.cmp",
        version = vim.version.range("^1"),
    },
    { src = "https://github.com/vieitesss/command.nvim", version = "main" },
    { src = "https://github.com/zbirenbaum/copilot.lua" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/echasnovski/mini.icons" },
    { src = "https://github.com/echasnovski/mini.ai" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/stevearc/conform.nvim" },
})

vim.env.PATH = vim.fn.stdpath("data")
    .. "/mason/bin:"
    .. vim.fn.expand("~/.cargo/bin")
    .. ":"
    .. vim.env.PATH

-- Mini icons (load first for other plugins to use)
require("mini.icons").setup()

-- Mini ai (text objects: iq/aq for quotes, ib/ab for brackets, etc.)
require("mini.ai").setup({ n_lines = 500 })

-- Catppuccin colorscheme
require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = false,
    term_colors = true,
    integrations = {
        gitsigns = true,
        mini = { enabled = true },
        blink_cmp = true,
    },
})

-- Snacks.nvim
require("snacks").setup({
    picker = { enabled = true },
    notifier = { enabled = true, timeout = 3000 },
    indent = { enabled = true },
    input = { enabled = true },
    dim = { enabled = true },
    gitbrowse = { enabled = true },
})

-- Which-key (shows pending keybindings)
require("which-key").setup({
    delay = 0,
    icons = {
        mappings = true,
        keys = {},
    },
    spec = {
        { "<leader>s", group = "Search" },
        { "<leader>F", group = "FzfLua" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Git Hunks" },
        { "<leader>t", group = "Tabs/Toggle" },
        { "<leader>o", group = "Open" },
        { "<leader>d", group = "Diagnostics" },
        { "<leader>c", group = "Command" },
        { "<leader>u", group = "UI/Toggle" },
        { "<leader>r", group = "Rust" },
    },
})

require("command").setup({})
require("mason").setup({})

-- Copilot (AI completion via LSP)
require("copilot").setup({
    suggestion = { enabled = false }, -- We use blink.cmp popup instead
    panel = { enabled = false },
})

-- Copilot icon highlight (GitHub green)
vim.api.nvim_set_hl(0, "BlinkCmpKindCopilot", { fg = "#6CC644" })
require("gitsigns").setup({
    signcolumn = false,
    attach_to_untracked = true,
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },
    on_attach = function(bufnr)
        local gitsigns = require("gitsigns")
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "]c", bang = true })
            else
                gitsigns.nav_hunk("next")
            end
        end, { desc = "Next git hunk" })

        map("n", "[c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "[c", bang = true })
            else
                gitsigns.nav_hunk("prev")
            end
        end, { desc = "Previous git hunk" })

        -- Actions (visual mode)
        map("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Stage hunk" })
        map("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Reset hunk" })

        -- Actions (normal mode)
        map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
        map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
        map(
            "n",
            "<leader>hu",
            gitsigns.undo_stage_hunk,
            { desc = "Undo stage hunk" }
        )
        map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
        map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
        map("n", "<leader>hb", gitsigns.blame_line, { desc = "Blame line" })
        map("n", "<leader>hB", function()
            gitsigns.blame_line({ full = true })
        end, { desc = "Blame line (full)" })
        map(
            "n",
            "<leader>hd",
            gitsigns.diffthis,
            { desc = "Diff against index" }
        )
        map("n", "<leader>hD", function()
            gitsigns.diffthis("@")
        end, { desc = "Diff against last commit" })

        -- Toggles
        map(
            "n",
            "<leader>tb",
            gitsigns.toggle_current_line_blame,
            { desc = "Toggle line blame" }
        )
        map(
            "n",
            "<leader>td",
            gitsigns.preview_hunk_inline,
            { desc = "Toggle deleted inline" }
        )
    end,
})
require("blink.cmp").setup({
    fuzzy = { implementation = "prefer_rust_with_warning" },
    signature = { enabled = true },
    keymap = {
        preset = "default",
        ["<C-space>"] = {},
        ["<C-p>"] = {},
        ["<Tab>"] = {},
        ["<S-Tab>"] = {},
        ["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-n>"] = { "select_and_accept" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-b>"] = { "scroll_documentation_down", "fallback" },
        ["<C-f>"] = { "scroll_documentation_up", "fallback" },
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-h>"] = { "snippet_backward", "fallback" },
        -- ["<C-e>"] = { "hide" },
    },

    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "normal",
    },

    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        },
    },

    cmdline = {
        keymap = {
            preset = "inherit",
            ["<CR>"] = { "accept_and_enter", "fallback" },
        },
    },

    sources = {
        default = { "copilot", "lsp" }, -- Copilot first for priority in menu
        providers = {
            copilot = {
                name = "Copilot",
                module = "sources.copilot",
                score_offset = 100, -- Boost Copilot to top of completion list
                async = true,
                enabled = function()
                    return vim.tbl_contains({
                        "javascript", "javascriptreact",
                        "typescript", "typescriptreact",
                        "html", "css", "scss",
                        "json", "jsonc",
                        "vue", "svelte", "astro",
                    }, vim.bo.filetype)
                end,
                opts = {
                    max_completions = 3,
                    -- TRIGGER BEHAVIOR OPTIONS:
                    -- debounce = 75,    -- Default: wait 75ms after typing
                    -- debounce = false, -- Instant: trigger on every keystroke
                    -- debounce = 200,   -- Slower: fewer API calls, less responsive
                },
            },
        },
    },
})

local actions = require("fzf-lua.actions")
require("fzf-lua").setup({
    winopts = {
        height = 1,
        width = 1,
        backdrop = 85,
        preview = {
            horizontal = "right:70%",
        },
    },
    keymap = {
        builtin = {
            ["<C-f>"] = "preview-page-down",
            ["<C-b>"] = "preview-page-up",
            ["<C-p>"] = "toggle-preview",
        },
        fzf = {
            ["ctrl-a"] = "toggle-all",
            ["ctrl-t"] = "first",
            ["ctrl-g"] = "last",
            ["ctrl-d"] = "half-page-down",
            ["ctrl-u"] = "half-page-up",
        },
    },
    actions = {
        files = {
            ["ctrl-q"] = actions.file_sel_to_qf,
            ["ctrl-n"] = actions.toggle_ignore,
            ["ctrl-h"] = actions.toggle_hidden,
            ["enter"] = actions.file_edit_or_qf,
        },
    },
})

-- Conform (formatting with prettier/eslint)
local prettier_fmt = { "prettierd", "prettier", stop_after_first = true }

local function js_formatter(bufnr)
    if
        vim.fs.root(bufnr, {
            "vite.config.ts",
            "vite.config.js",
            "vite.config.mts",
            "vite.config.mjs",
        })
    then
        return {} -- oxfmt LSP handles formatting via lsp_format = "fallback"
    end
    return prettier_fmt
end

require("conform").setup({
    notify_on_error = false,
    format_on_save = function(bufnr)
        return nil
        -- local disable_filetypes = { c = true, cpp = true }
        -- if disable_filetypes[vim.bo[bufnr].filetype] then
        --     return nil
        -- end
        -- return {
        --     timeout_ms = 500,
        --     lsp_format = "fallback",
        -- }
    end,
    formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = js_formatter,
        typescript = js_formatter,
        typescriptreact = js_formatter,
        javascriptreact = js_formatter,
        json = prettier_fmt,
        html = prettier_fmt,
        css = prettier_fmt,
        markdown = prettier_fmt,
    },
})

require("oil").setup({
    default_file_explorer = true,
    columns = {
        "permissions",
        "size",
    },
    constrain_cursor = "name",
    watch_for_changes = true,
    keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-v>"] = { "actions.select", opts = { vertical = true } },
        ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-l>"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },
    view_options = {
        show_hidden = true,
    },
})

-- vim.g.vimtex_imaps_enabled = 0
-- vim.g.vimtex_view_method = "skim"
-- vim.g.latex_view_general_viewer = "skim"
-- vim.g.latex_view_general_options =
--     "-reuse-instance -forward-search @tex @line @pdf"
-- vim.g.vimtex_compiler_method = "latexmk"
-- vim.g.vimtex_quickfix_open_on_warning = 0
-- vim.g.vimtex_quickfix_ignore_filters = {
--     "Underfull",
--     "Overfull",
--     "LaTeX Warning: .\\+ float specifier changed to",
--     "Package hyperref Warning: Token not allowed in a PDF string",
-- }
