---@type LazyPluginSpec
return {
  "neovim/nvim-lspconfig",
  dependencies = { "saghen/blink.cmp" },
  config = function()
    vim.lsp.enable({
      "gopls",
      "lua_ls",
      "nil_ls",
      "pyright",
      "rust_analyzer",
      "tailwindcss",
      "ts_ls",
      "cssls",
    })
  end,
}
