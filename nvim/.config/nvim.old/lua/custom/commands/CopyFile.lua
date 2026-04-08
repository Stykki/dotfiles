vim.api.nvim_create_user_command('YankFilePath', function(opts)
  local filepath = vim.fn.expand '%'
  vim.fn.setreg('+', filepath) -- write to clippoard
end, { nargs = 0, desc = 'Open quickfix list with conflict markers' })

return
