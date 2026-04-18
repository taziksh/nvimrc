--- Options
vim.opt.number = true
vim.opt.relativenumber = true

--- Package manager
require("config.lazy")
--- Language server configs
vim.lsp.enable("luals")
vim.lsp.enable("vtsls")
vim.lsp.enable("basedpyright")
vim.lsp.enable("sourcekit")
vim.lsp.enable("copilot")
