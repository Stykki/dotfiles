-- ElixirLS: the mature, batteries-included Elixir language server.
-- Install with `:MasonInstall elixir-ls` (provides the `elixir-ls` wrapper).
--
-- Alternatives (also on Mason) if you want to try the newer servers:
--   * `expert`  - the official successor, still early days
--   * `lexical` - fast, but weaker HEEx support today

---@type vim.lsp.Config
return {
    cmd = { "elixir-ls" },
    -- eelixir = .eex/.leex, heex = Phoenix templates, surface = .sface
    filetypes = { "elixir", "eelixir", "heex", "surface" },

    -- Nvim's default `root_markers` stops at the *nearest* mix.exs, which
    -- breaks umbrella apps (`apps/my_app/mix.exs`). Walk all the way up so the
    -- server is started once, at the umbrella root, and can see sibling apps.
    root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        if fname == "" then
            return
        end
        local matches = vim.fs.find("mix.exs", {
            path = fname,
            upward = true,
            limit = math.huge,
            stop = vim.uv.os_homedir(),
        })
        local outermost = matches[#matches]
        on_dir(
            outermost and vim.fs.dirname(outermost)
                or vim.fs.root(bufnr, { ".git" })
        )
    end,

    settings = {
        elixirLS = {
            -- Dialyzer is the big win for Phoenix contexts/schemas, but the
            -- first build after `mix deps.get` is slow. Set to false if the
            -- CPU fan bothers you.
            dialyzerEnabled = true,
            -- Don't let the server run `mix deps.get` behind your back.
            fetchDeps = false,
            enableTestLenses = false,
            suggestSpecs = true,
        },
    },
}
