--- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.undofile = true

--- Indentation is 4 spaces by default
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

--- Override: web languages use 2 spaces
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "javascript", "javascriptreact", "typescript", "typescriptreact",
    "json", "jsonc", "html", "css", "scss", "yaml", "lua",
  },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
  end,
})

--- Package manager
require("config.lazy")
--- Language server configs
vim.lsp.enable("luals")
vim.lsp.enable("vtsls")
vim.lsp.enable("basedpyright")
vim.lsp.enable("sourcekit")
vim.lsp.enable("copilot")
