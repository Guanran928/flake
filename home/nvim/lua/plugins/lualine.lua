---@type LazyPluginSpec
return {
  "nvim-lualine/lualine.nvim", -- status line
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- for filetype icons
  },
  init = function()
    vim.opt.showmode = false
  end,
  opts = {
    options = {
      -- disable separators
      section_separators = "",
      component_separators = "",
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "diff", "diagnostics" },
      lualine_c = { "filename" },
      lualine_x = { "filetype" },
      lualine_y = {},
      lualine_z = { "location" },
    },
  },
}
