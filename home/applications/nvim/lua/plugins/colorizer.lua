---@type LazyPluginSpec
return {
  -- maintained fork of "norcalli/nvim-colorizer.lua"
  "catgoose/nvim-colorizer.lua",
  enabled = false,
  event = "VeryLazy",
  opts = {
    lazy_load = true,
    buftypes = { "*", "!nofile" },
    user_default_options = {
      names = false,
      css = true,
      tailwind = true,
      mode = "virtualtext",
      virtualtext_inline = "before",
    },
  },
}
