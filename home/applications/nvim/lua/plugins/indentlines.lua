---@type LazyPluginSpec
return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  main = "ibl",
  opts = {
    indent = {
      char = "▏",
    },
  },
}
