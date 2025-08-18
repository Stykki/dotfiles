-- Define a command "EzEcBuffer" that can be invoked in Neovim
vim.api.nvim_create_user_command("EzEcBuffer", function(opts)
end, { nargs = 0, desc = "Encrypt the current buffer contents" })

vim.api.nvim_create_user_command("EzDcBuffer", function(opts)
end, { nargs = 0, desc = "Decrypt the current buffer contents" })

return




