-- Generate a git repository web link for the current file/selection/line
-- Supports GitHub, GitLab, and Bitbucket

local function get_git_remote_url()
  local handle = io.popen 'git remote get-url origin 2>/dev/null'
  if not handle then
    return nil
  end
  local url = handle:read '*l'
  handle:close()
  return url
end

local function get_git_branch()
  local handle = io.popen 'git rev-parse --abbrev-ref HEAD 2>/dev/null'
  if not handle then
    return nil
  end
  local branch = handle:read '*l'
  handle:close()
  return branch
end

local function get_git_root()
  local handle = io.popen 'git rev-parse --show-toplevel 2>/dev/null'
  if not handle then
    return nil
  end
  local root = handle:read '*l'
  handle:close()
  return root
end

local function convert_remote_to_web_url(remote_url)
  if not remote_url then
    return nil
  end

  -- Remove trailing .git if present
  remote_url = remote_url:gsub('%.git$', '')

  -- Convert SSH URLs to HTTPS
  -- git@github.com:user/repo -> https://github.com/user/repo
  if remote_url:match '^git@' then
    remote_url = remote_url:gsub('^git@([^:]+):', 'https://%1/')
  end

  -- Handle ssh:// URLs
  -- ssh://git@github.com/user/repo -> https://github.com/user/repo
  if remote_url:match '^ssh://' then
    remote_url = remote_url:gsub('^ssh://[^@]+@', 'https://')
  end

  return remote_url
end

local function get_relative_file_path()
  local git_root = get_git_root()
  if not git_root then
    return nil
  end

  local absolute_path = vim.fn.expand '%:p'
  -- Make path relative to git root
  local relative_path = absolute_path:gsub('^' .. vim.pesc(git_root) .. '/', '')
  return relative_path
end

local function build_line_anchor(base_url, start_line, end_line)
  -- Detect the git hosting service and format accordingly
  local is_github = base_url:match 'github%.com'
  local is_gitlab = base_url:match 'gitlab%.com' or base_url:match 'gitlab%.'
  local is_bitbucket = base_url:match 'bitbucket%.org'

  if start_line == end_line then
    -- Single line
    if is_github then
      return string.format('#L%d', start_line)
    elseif is_gitlab then
      return string.format('#L%d', start_line)
    elseif is_bitbucket then
      return string.format('#lines-%d', start_line)
    else
      -- Default to GitHub-style
      return string.format('#L%d', start_line)
    end
  else
    -- Line range
    if is_github then
      return string.format('#L%d-L%d', start_line, end_line)
    elseif is_gitlab then
      return string.format('#L%d-%d', start_line, end_line)
    elseif is_bitbucket then
      return string.format('#lines-%d:%d', start_line, end_line)
    else
      -- Default to GitHub-style
      return string.format('#L%d-L%d', start_line, end_line)
    end
  end
end

local function build_git_link(start_line, end_line)
  local remote_url = get_git_remote_url()
  if not remote_url then
    vim.notify('Could not get git remote URL', vim.log.levels.ERROR)
    return nil
  end

  local branch = get_git_branch()
  if not branch then
    vim.notify('Could not get git branch', vim.log.levels.ERROR)
    return nil
  end

  local file_path = get_relative_file_path()
  if not file_path then
    vim.notify('Could not get file path relative to git root', vim.log.levels.ERROR)
    return nil
  end

  local web_url = convert_remote_to_web_url(remote_url)
  if not web_url then
    vim.notify('Could not convert remote URL to web URL', vim.log.levels.ERROR)
    return nil
  end

  -- Detect the git hosting service and build URL accordingly
  local is_github = web_url:match 'github%.com'
  local is_gitlab = web_url:match 'gitlab%.com' or web_url:match 'gitlab%.'
  local is_bitbucket = web_url:match 'bitbucket%.org'

  local full_url
  if is_github then
    full_url = string.format('%s/blob/%s/%s', web_url, branch, file_path)
  elseif is_gitlab then
    full_url = string.format('%s/-/blob/%s/%s', web_url, branch, file_path)
  elseif is_bitbucket then
    full_url = string.format('%s/src/%s/%s', web_url, branch, file_path)
  else
    -- Default to GitHub-style
    full_url = string.format('%s/blob/%s/%s', web_url, branch, file_path)
  end

  -- Add line anchor if lines are specified
  if start_line and end_line then
    full_url = full_url .. build_line_anchor(web_url, start_line, end_line)
  end

  return full_url
end

vim.api.nvim_create_user_command('GitLink', function(opts)
  local start_line = opts.line1
  local end_line = opts.line2

  -- If no range was specified (not visual mode), use current line
  if opts.range == 0 then
    start_line = vim.fn.line '.'
    end_line = start_line
  end

  local url = build_git_link(start_line, end_line)
  if url then
    vim.fn.setreg('+', url)
    vim.notify('Copied: ' .. url, vim.log.levels.INFO)
  end
end, {
  range = true,
  desc = 'Generate git web link for current file/selection and copy to clipboard',
})

return
