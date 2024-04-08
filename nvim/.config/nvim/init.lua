require("bootstrap")
require("mappings")


------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.opt.scrolloff = 10

vim.api.nvim_set_option("clipboard","unnamedplus")

require("lazy").setup("plugins")

------
