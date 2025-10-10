vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { silent = true, desc = "Show diagnostics" })

vim.keymap.set("n", "]g", function()
  vim.diagnostic.jump({ count = 1 })
end)

vim.keymap.set("n", "[g", function()
  vim.diagnostic.jump({ count = -1 })
end)
