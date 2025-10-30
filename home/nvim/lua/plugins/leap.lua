---@type LazyPluginSpec
return {
  "ggandor/leap.nvim",
  keys = {
    { "s", mode = { "n", "x", "o" }, "<Plug>(leap)" },
    { "S", mode = { "n" }, "<Plug>(leap-from-window)" },
  },
  dependencies = {
    { "tpope/vim-repeat", event = "VeryLazy" },
  },
}
