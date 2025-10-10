---@type LazyPluginSpec
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      {
        path = "lazy.nvim",
        words = { "Lazy.*Spec" },
      },
    },
  },
}
