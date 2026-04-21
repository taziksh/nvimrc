return {
  "joshdick/onedark.vim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.opt.termguicolors = true
    vim.cmd.colorscheme("onedark")
  end,
}
