-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- Better file reading
opt.autoread = true
opt.autowrite = true

-- Cursorline
opt.cursorline = true

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Breakindent
opt.breakindent = true

-- Mouse
vim.cmd([[
  aunmenu PopUp.How-to\ disable\ mouse
  aunmenu PopUp.-2-
]])
opt.mouse = "a"

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Searching
opt.ignorecase = true
opt.smartcase = true
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- System integration
-- https://github.com/nvim-lua/kickstart.nvim/blob/7201dc480134f41dd1be1f8f9b8f8470aac82a3b/init.lua#L113-L119
vim.schedule(function()
  opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
end)
opt.swapfile = false
opt.undofile = true

-- Tab settings
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2

-- Visuals
opt.laststatus = 3
opt.cmdheight = 0 -- Remove gap between lualine and tmux
opt.signcolumn = "yes" -- Prevents shifting
opt.fillchars = { eob = " " } -- Remove tilde on empty lines

-- Restore cursor after exit
-- https://codeberg.org/dnkl/foot/issues/1891#issuecomment-2557228
vim.api.nvim_create_autocmd("VimLeave", {
  pattern = "*",
  callback = function()
    opt.guicursor = ""
    vim.fn.chansend(vim.v.stderr, "\x1b[ q")
  end,
})

vim.diagnostic.config({
  virtual_text = {
    -- HACK: There is a space before the diagnostic text for some
    --       reason, therefore putting another space at the end of the
    --       diagnostic text to center it.
    prefix = "",
    suffix = " ",
    virt_text_pos = "eol_right_align",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
})

vim.lsp.inlay_hint.enable()

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client:supports_method("textDocument/documentColor") then
      vim.lsp.document_color.enable(true, args.buf)
    end
  end,
})

require("vim._core.ui2").enable({})
