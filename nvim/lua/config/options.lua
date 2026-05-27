local opt = vim.opt

opt.clipboard = "unnamedplus"

opt.number = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

opt.smartcase = true

opt.fileencodings = "utf-8,cp932,euc-jp,iso-2022-jp,default,latin1"

opt.cursorline = true
opt.showmode = true
opt.showcmd = true

opt.autoread = true
opt.updatetime = 500

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" and vim.fn.bufexists("%") == 1 then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
  end,
})

