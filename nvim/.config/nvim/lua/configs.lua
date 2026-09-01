local opt = vim.opt

opt.signcolumn = "yes:1"
opt.termguicolors = true
opt.ignorecase = true
opt.swapfile = false
opt.autoindent = true
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.shiftround = true
opt.listchars = "tab: ,multispace:|   ,eol:󰌑"
opt.list = true
opt.number = true
opt.relativenumber = true
opt.numberwidth = 2
opt.wrap = false
opt.cursorline = true
opt.scrolloff = 8
opt.inccommand = "nosplit"
opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
opt.undofile = true
opt.winborder = "rounded"
opt.hlsearch = false
opt.clipboard = "unnamedplus"

vim.cmd.filetype("plugin indent on")

vim.g.netrw_liststyle = 1
vim.g.netrw_sort_by = "size"

local ok_ui2, ui2 = pcall(require, "vim._core.ui2")
if ok_ui2 and type(ui2.enable) == "function" then
    ui2.enable({
        enable = true,
        msg = {
            targets = "cmd",
            timeout = 4000,
        },
    })
end



vim.opt.foldenable = false
vim.opt.foldlevel = 99

vim.cmd.colorscheme("catppuccin")

-- Local Settings (Apply these via autocmd or ftplugin for specific files)
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'typescript', 'javascript', 'rust', 'zig', 'cpp', 'c', 'python', 'elixir', 'heex' },
  callback = function()
    -- `vim.wo[0][0]` scopes the option to this buffer in this window, so it
    -- does not leak into other buffers shown in the same window.
    vim.wo[0][0].foldmethod = 'expr'
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end,
})
