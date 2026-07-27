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

-- vim.ui.open (gx, Snacks explorer の O 等) を Windows 側アプリで開く。
-- wslview 未導入のため explorer.exe + wslpath でパス変換して起動する。
-- 画像は JPEGView で開く (フォトはコマンドライン起動だとフォルダ内の
-- 矢印キー移動ができないため)。explorer.exe は成功時も終了コード 1 を
-- 返すため結果は検査しない。
if vim.fn.has("wsl") == 1 then
  local jpegview = "/mnt/c/Program Files/JPEGView/JPEGView.exe"
  local image_ext = {
    png = true, jpg = true, jpeg = true, gif = true, webp = true,
    bmp = true, tif = true, tiff = true, ico = true, avif = true,
  }
  vim.ui.open = function(path)
    if not path:match("^%a+://") then
      local ext = (path:match("%.(%w+)$") or ""):lower()
      path = vim.trim(vim.fn.system({ "/bin/wslpath", "-w", vim.fn.fnamemodify(path, ":p") }))
      if image_ext[ext] and vim.uv.fs_stat(jpegview) then
        -- WSL interop で直接起動するとキーマップが読み込まれず
        -- キーボード操作が全滅するため ShellExecute (Start-Process) 経由で起動する
        vim.system({
          "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe",
          "-NoProfile",
          "-Command",
          ("Start-Process -FilePath 'C:\\Program Files\\JPEGView\\JPEGView.exe' -ArgumentList '\"%s\"' -WorkingDirectory 'C:\\'"):format(path),
        }, { detach = true })
        return
      end
    end
    vim.system({ "/mnt/c/Windows/explorer.exe", path }, { detach = true })
  end
end

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

