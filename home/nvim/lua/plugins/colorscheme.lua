---@type LazyPluginSpec
return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      colors = {
        theme = {
          all = {
            ui = {
              -- Transparent line number
              bg_gutter = "none",
            },
          },
        },
      },
    })
    vim.cmd([[ colorscheme kanagawa-dragon ]])
  end,
}
