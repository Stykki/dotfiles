
local plugins = {
  {
    "zbirenbaum/copilot.lua",
    config = function()
      require("copilot").setup({
          suggestion = { enabled = false },
          panel = { enabled = false },
      })
    end,
    lazy=false
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    config = function()
      local select = require('CopilotChat.select')
      require("CopilotChat").setup(
        {
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
          insert ='<Tab>',
        },
        close = {
          normal = 'q',
          insert = '<C-c>'
        },
        reset = {
          normal ='<C-l>',
          insert = '<C-l>'
        },
        submit_prompt = {
          normal = '<CR>',
          insert = '<C-m>'
        },
        accept_diff = {
          normal = '<C-y>',
          insert = '<C-y>'
        },
        yank_diff = {
          normal = 'cpgy',
        },
        show_diff = {
          normal = 'cpgd'
        },
        show_system_prompt = {
          normal = 'cpgp'
        },
        show_user_selection = {
          normal = 'cpgs'
        },
      },
    })
    end,


    lazy=false
  },
  {
    "neovim/nvim-lspconfig",
       dependencies = {
     "jose-elias-alvarez/null-ls.nvim",
     config = function()
       require "custom.configs.null-ls"
     end,
    },
    config = function ()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
   {
    "nvim-tree/nvim-tree.lua",
    opts = function()
      return require "custom.configs.nvimtree"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "rust-analyzer",
        "svelte",
        "tailwindcss",
        "typescript-language-server",
        "prettierd",
        'eslint-lsp'
      }
    }
  },
  {
    'saecki/crates.nvim',
    ft = {"rust", "toml"},
    config = function(_, opts)
      local crates = require('crates')
      crates.setup(opts)
    end,
  },
  {
    "hrsh7th/nvim-cmp",
      dependencies = {
        {
          "zbirenbaum/copilot-cmp",
          config = function()
            require("copilot_cmp").setup()
          end,
        },
      },
    opts = function()
      local M = require "plugins.configs.cmp"
      table.insert(M.sources, {name = "crates"})
      table.insert(M.sources, {name = "copilot"})
      return M
    end
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { 'xiyaowong/telescope-emoji.nvim' },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
    },
    opts = function()
      local a = require "plugins.configs.telescope"
      local b = require "custom.configs.telescope"
      return vim.tbl_deep_extend("force", a, b)
    end,
  },
  {
    "ruifm/gitlinker.nvim",
    lazy = false,
    config = function()
      require("gitlinker").setup()
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" }
    }
  },
  {
    "epwalsh/obsidian.nvim",
    lazy = true,
    event = { "BufReadPre " .. vim.fn.expand "~" .. "/Documents/vault/v1/**.md" },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    opts = {
      dir = "~/Documents/vault/v1",  -- no need to call 'vim.fn.expand' here
    },
  }
}

return plugins
