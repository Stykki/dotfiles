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

    ["<leader>bo"] = {"<cmd>%bd|e#<cr>", "Close all buffers but the current one"},
    ["P"] = { "\"0p", "Paste from copy register"},
    ["<leader>cf"] = {"<cmd> let @+=@% <CR>", "Coppy current filepath"},
    ["<leader>sc"] = { "<cmd> set rnu! <CR>", "Source config" },
    ["<leader>se"] = { "<cmd> cd ~/.config/nvim <CR>", "Edit config" },
    ["<leader>sl"] = { "<cmd> Telescope live_grep_args <CR>", "Live grep args" },
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


