-- Generate a relative path with line/column info in LSP/grep format
-- Examples:
--   Cursor:    ./src/main/file.txt:84:29
--   Selection: ./src/main/file.txt:84-92

local function get_relative_path()
  local absolute_path = vim.fn.expand '%:p'
  local cwd = vim.fn.getcwd()

  -- Make path relative to cwd
  if absolute_path:sub(1, #cwd) == cwd then
    local relative = absolute_path:sub(#cwd + 2) -- +2 to skip the trailing /
    return './' .. relative
  end

  -- Fallback to just the filename if not under cwd
  return './' .. vim.fn.expand '%:t'
end

local function build_path_reference(start_line, start_col, end_line, include_col)
  local path = get_relative_path()

  if start_line == end_line then
    -- Single line - include column if requested
    if include_col and start_col then
      return string.format('%s:%d:%d', path, start_line, start_col)
    else
      return string.format('%s:%d', path, start_line)
    end
  else
    -- Line range
    return string.format('%s:%d-%d', path, start_line, end_line)
  end
end

vim.api.nvim_create_user_command('CopyPath', function(opts)
  local start_line, start_col, end_line

  if opts.range == 0 then
    -- No range - use cursor position
    local cursor = vim.api.nvim_win_get_cursor(0)
    start_line = cursor[1]
    start_col = cursor[2] + 1 -- Convert 0-indexed to 1-indexed
    end_line = start_line
  else
    -- Visual selection or range
    start_line = opts.line1
    end_line = opts.line2
    start_col = nil -- Don't include column for ranges
  end

  -- Check for bang (!) to exclude column
  local include_col = not opts.bang

  local reference = build_path_reference(start_line, start_col, end_line, include_col)
  vim.fn.setreg('+', reference)
  vim.notify('Copied: ' .. reference, vim.log.levels.INFO)
end, {
  range = true,
  bang = true,
  desc = 'Copy relative file path with line/column (LSP/grep format). Use ! to exclude column.',
})

return
