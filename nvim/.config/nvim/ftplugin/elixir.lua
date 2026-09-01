-- Elixir buffer-local setup (also loaded for Phoenix projects)

-- Elixir's formatter is hard-coded to 2 spaces; match it.
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

-- `?` and `!` are part of identifiers (`valid?`, `save!`), `:` starts atoms.
vim.opt_local.iskeyword:append({ "?", "!" })

local function mix(args)
    return function()
        vim.cmd("silent! write")
        vim.cmd("!mix " .. args)
    end
end

local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = true, silent = true, desc = desc })
end

map("<leader>eb", mix("compile"), "Mix compile")
map("<leader>et", mix("test"), "Mix test")
map("<leader>eT", function()
    vim.cmd("silent! write")
    vim.cmd("!mix test " .. vim.fn.expand("%") .. ":" .. vim.fn.line("."))
end, "Mix test (line under cursor)")
map("<leader>ec", mix("credo --strict"), "Mix credo")
map("<leader>ed", mix("deps.get"), "Mix deps.get")
map("<leader>ef", mix("format"), "Mix format (project)")

-- Phoenix
map("<leader>em", mix("ecto.migrate"), "Mix ecto.migrate")
map("<leader>eM", mix("ecto.rollback"), "Mix ecto.rollback")
map("<leader>es", mix("phx.routes"), "Mix phx.routes")
