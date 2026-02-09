---@type LazyPluginSpec
return {
  "https://codeberg.org/andyg/leap.nvim",
  keys = {
    { "s", mode = { "n", "x", "o" }, "<Plug>(leap)" },
    { "S", mode = { "n" }, "<Plug>(leap-from-window)" },
  },
  dependencies = {
    { "tpope/vim-repeat", event = "VeryLazy" },
  },
}
