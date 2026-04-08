return {
  'stykki/project-local',
  -- dir = '/Users/vigniromarvignissonlove/Documents/code/lua/project_local/',
  -- dev = true,
  config = function()
    require('project_local.core').setup()
  end,
}
