return {
  "p00f/alabaster.nvim",
  name = "alabaster",
  lazy = false,
  priority = 1000,
  config = function()
    vim.opt.termguicolors = true
    vim.cmd.colorscheme("alabaster")

    vim.api.nvim_create_autocmd("OptionSet", {
      pattern = "background",
      callback = function() vim.cmd.colorscheme("alabaster") end,
    })
  end,
}
