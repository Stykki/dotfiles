
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
