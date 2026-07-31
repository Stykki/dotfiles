-- WGSL buffer-local setup

vim.bo.commentstring = "// %s"
vim.bo.comments = "s1:/*,mb:*,ex:*/,://"

vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true

-- C-like indenting is a good enough fit for WGSL
vim.bo.cindent = true
vim.bo.cinoptions = "L0,l1,b0,(s,U1,j1,J1,m1"
