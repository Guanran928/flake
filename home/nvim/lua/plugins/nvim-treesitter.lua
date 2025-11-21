---@type LazyPluginSpec
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master", -- `main` is too restricted
  build = ":TSUpdate",
  event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
  lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
  opts = {
    ensure_installed = {
      -- keep-sorted start
      "bash",
      "c",
      "comment",
      "diff",
      "html",
      "javascript",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "nix",
      "rust",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
      -- keep-sorted end
    },

    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
    folds = { enable = true },
  },
  config = function(_, opts)
    require("nvim-treesitter.install").prefer_git = true
    require("nvim-treesitter.configs").setup(opts)
  end,
}
