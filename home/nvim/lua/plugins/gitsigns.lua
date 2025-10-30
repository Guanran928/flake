---@type LazyPluginSpec
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  opts = {},
  keys = {
    {
      "<leader>b",
      function()
        require("gitsigns").blame_line()
      end,
      desc = "Blame current line",
    },
    {
      "<leader>B",
      function()
        require("gitsigns").blame()
      end,
      desc = "Blame",
    },
  },
}
