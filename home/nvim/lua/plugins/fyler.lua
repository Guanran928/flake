---@type LazyPluginSpec
return {
  "A7Lavinraj/fyler.nvim",
  dependencies = { "nvim-mini/mini.icons" },
  opts = {},
  keys = {
    {
      "<leader>e",
      function()
        -- Focus existing Fyler window if available
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local cfg = vim.api.nvim_win_get_config(win)
          if cfg.relative ~= "" then -- floating window
            local buf = vim.api.nvim_win_get_buf(win)
            local name = vim.api.nvim_buf_get_name(buf)
            if name:match("fyler") then
              vim.api.nvim_set_current_win(win)
              return
            end
          end
        end

        -- No existing floating window, open a new one
        require("fyler").open({ kind = "float" })
      end,
      desc = "Open Fyler View",
    },
  },
}
