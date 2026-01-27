vim.api.nvim_create_user_command('BufOnly', function()
  vim.cmd '%bd|e#|bd#'
end, { desc = 'Close all buffers except the current one' })
