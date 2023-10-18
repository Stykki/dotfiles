--@type ChadrcConfig 
local M = {}
M.plugins = "custom.plugins"
M.mappings = require 'custom.mappings'

vim.wo.relativenumber = true

vim.g.vscode_snippets_path = vim.fn.stdpath "config" .. '/lua/custom/snippets'

local opt = vim.opt


opt.scrolloff = 8
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false

M.ui = {
  theme = 'catppuccin',
  telescope = { style = "bordered" }
}


 return M


