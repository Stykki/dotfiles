require("bootstrap")
require("mappings")


------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

require("lazy").setup("plugins")

------
