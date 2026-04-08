-- Set leader keys BEFORE any plugin loads
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require 'plugins'
require 'configs'
require 'lsp'
require 'keymaps'
require 'commands'
require 'statusline'
require 'autocmds'
