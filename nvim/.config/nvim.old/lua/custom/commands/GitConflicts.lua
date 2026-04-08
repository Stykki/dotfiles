vim.api.nvim_create_user_command('GitConflicts', function(opts)
  -- Run git diff --check and get output as a string
  local result = vim.system({ 'git', 'diff', '--check' }):wait()

  -- Parse the output lines
  local qf_entries = {}
  for line in result.stdout:gmatch '[^\r\n]+' do
    -- git diff --check output format: filename:line: detail
    local file, lnum, msg = line:match '([^:]+):(%d+): (.*)'
    if file and lnum then
      table.insert(qf_entries, {
        filename = file,
        lnum = tonumber(lnum),
        text = msg or 'Conflict marker',
      })
    end
  end

  -- Set the quickfix list
  vim.fn.setqflist(qf_entries, 'r')

  -- Open the quickfix window if we found conflicts
  if #qf_entries > 0 then
    vim.cmd 'copen'
  else
    vim.notify('No conflict markers found', vim.log.levels.INFO)
  end
end, { nargs = 0, desc = 'Open quickfix list with conflict markers' })

return
