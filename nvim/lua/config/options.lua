local opt = vim.opt

opt.clipboard = "unnamedplus"

-- Windows版wezterm + SSH mux 構成では SSH_TTY が立たず OSC 52 の自動検出が
-- 効かないため明示指定する (interop 無効のため win32yank も使えない)。
-- wezterm はクリップボード読み取り (OSC 52 query) 非対応なので、paste は
-- 無名レジスタへのフォールバックとし、Windows→nvim はターミナルのペーストで行う。
local osc52 = require("vim.ui.clipboard.osc52")
local function paste_fallback()
  return { vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
end
vim.g.clipboard = {
  name = "OSC 52",
  copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
  paste = { ["+"] = paste_fallback, ["*"] = paste_fallback },
}

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

