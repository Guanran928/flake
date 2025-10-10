---@type LazyPluginSpec
return {
  "saghen/blink.cmp",
  version = "1.*",
  event = "InsertEnter",

  dependencies = {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    lazy = true,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        local luasnip = require("luasnip")
        luasnip.filetype_extend("javascriptreact", { "html" })
        luasnip.filetype_extend("typescriptreact", { "html" })
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "enter" },
    snippets = { preset = "luasnip" },
    completion = {
      documentation = { auto_show = true },
      list = { selection = { preselect = false } },
    },
    sources = {
      default = { "lazydev", "lsp", "path", "snippets" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },
  },
}
