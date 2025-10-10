---@type LazyPluginSpec
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
  lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "comment",
      "diff",
      "html",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "nix",
      "toml",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },

    highlight = { enable = true },
    indent = { enable = true },
    folds = { enable = true },
  },
}
