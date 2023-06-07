--@type ChadrcConfig 
local M = {}
M.plugins = "custom.plugins"
M.mappings = require 'custom.mappings'

vim.wo.relativenumber = true

local opt = vim.opt


opt.scrolloff = 8
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
-- opt.foldenable = true

M.ui = {
  theme = 'catppuccin',
  telescope = { style = "bordered" }
}


 return M


