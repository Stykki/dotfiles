return {
  'CopilotC-Nvim/CopilotChat.nvim',
  branch = 'canary',
  dependencies = {
    { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
    { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
  },
  config = function()
    local select = require 'CopilotChat.select'
    require('CopilotChat').setup {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
      prompts = {
        ValidateDiff = {
          prompt = 'Check for TODOS FIXMEs console.logs etc in the selection and tell me which files and line numbers include them.',
          selection = select.gitdiff,
        },
        ReviewChanges = {
          prompt = 'Review the selection as a professional code reviewer.',
          selection = select.gitdiff,
        },
      },
      mappings = {
        complete = {
          detail = 'Use @<Tab> or /<Tab> for options.',
          insert = '<Tab>',
        },
        close = {
          normal = 'q',
          insert = '<C-c>',
        },
        reset = {
          normal = '<C-l>',
          insert = '<C-l>',
        },
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-m>',
        },
        accept_diff = {
          normal = '<C-y>',
          insert = '<C-y>',
        },
        yank_diff = {
          normal = 'cpgy',
        },
        show_diff = {
          normal = 'cpgd',
        },
        show_system_prompt = {
          normal = 'cpgp',
        },
        show_user_selection = {
          normal = 'cpgs',
        },
      },
    }
  end,

  lazy = false,
}
