---@type LazyPluginSpec
return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    local function on_attach(bufnr)
      local api = require("nvim-tree.api")

      -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#h-j-k-l-style-navigation-and-editing
      local function edit_or_open()
        local node = api.tree.get_node_under_cursor()

        if node.nodes ~= nil then
          api.node.open.edit()
        else
          api.node.open.edit()
          api.tree.close()
        end
      end

      local function opts(desc)
        return {
          desc = "nvim-tree: " .. desc,
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
        }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      vim.keymap.set("n", "l", edit_or_open, opts("Edit or Open"))
      vim.keymap.set("n", "L", api.tree.expand_all, opts("Expand All"))
      vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Collapse"))
      vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
    end

    local function icons()
      return {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
      }
    end

    require("nvim-tree").setup({
      on_attach = on_attach,
      hijack_cursor = true,
      view = {
        float = {
          enable = true,
        },
      },
      renderer = {
        symlink_destination = false, -- usually too long
      },
      git = icons(),
      diagnostics = icons(),
      modified = icons(),
    })
  end,
  keys = {
    {
      "<leader>e",
      function()
        require("nvim-tree.api").tree.toggle({ find_file = true, focus = true })
      end,
      desc = "File Explorer",
    },
  },
}
