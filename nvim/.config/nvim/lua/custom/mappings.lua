local M = {}
M.crates = {
  n = {
    ['<leader>rcu'] = {
      function()
        require('crates').upgrade_all_crates()
      end,
      "update crates"
    },
  }
}

M.lspconfig = {
  plugin = true,
  n = {
   ["<leader>."] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "LSP code action",
    },
  }
}



 M.general = {
  n = {
    ["P"] = { "\"0p", "Paste from copy register"},
    ["<leader>sc"] = { "<cmd> set rnu! <CR>", "Source config" },
    ["<leader>se"] = { "<cmd> cd ~/.config/nvim <CR>", "Edit config" },
    ["<leader>sv"] = {
      function()
        vim.diagnostic.open_float()
      end,
      "Show error overlay"},
  },
  t = {
    ["<Esc>"] = { "<C-\\><C-n>", "Exit terminal mode"},
  }
}

return M


