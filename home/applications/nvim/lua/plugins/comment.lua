---@type LazyPluginSpec
return {
  "numToStr/Comment.nvim",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  event = { "BufReadPost", "BufWritePost", "BufNewFile" },
  config = function()
    local context_commentstring_integration = require("ts_context_commentstring.integrations.comment_nvim")

    require("Comment").setup({
      pre_hook = context_commentstring_integration.create_pre_hook(),
    })
  end,
}
