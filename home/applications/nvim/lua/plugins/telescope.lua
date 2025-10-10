---@type LazyPluginSpec
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  config = function()
    require("telescope").load_extension("fzf")
  end,
  cmd = "Telescope",
  keys = {
    { "<leader><leader>", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
    { "<leader>sf", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>sg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
    { "<leader>sb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
  },
}
