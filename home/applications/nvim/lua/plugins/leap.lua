---@type LazyPluginSpec
return {
  "ggandor/leap.nvim",
  dependencies = {
    "tpope/vim-repeat",
  },
  opts = {},
  config = function()
    require("leap").create_default_mappings()
  end,
}
