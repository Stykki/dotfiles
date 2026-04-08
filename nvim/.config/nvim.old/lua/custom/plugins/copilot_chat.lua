return {
  'CopilotC-Nvim/CopilotChat.nvim',
  branch = 'main',
  dependencies = {
    { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
  },
  opts = {
    model = 'gpt-5',
    debug = true, -- Enable debugging
  },
  lazy = false,
}
