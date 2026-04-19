return {
  "gbprod/yanky.nvim",
  opts = {},
  keys = {
    { "p",  "<Plug>(YankyPutAfter)",   mode = { "n", "x" } },
    { "P",  "<Plug>(YankyPutBefore)",  mode = { "n", "x" } },
    { "gp", "<Plug>(YankyGPutAfter)",  mode = { "n", "x" } },
    { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" } },
    { "<c-n>", "<Plug>(YankyNextEntry)" },
    { "<c-p>", "<Plug>(YankyPreviousEntry)" },
  },
}
