-- Ensure Linuxbrew is in PATH (needed when launched via wsl.exe -e without login shell)
local brew_bin = "/home/linuxbrew/.linuxbrew/bin"
if vim.uv.fs_stat(brew_bin) and not vim.env.PATH:find(brew_bin, 1, true) then
  vim.env.PATH = brew_bin .. ":" .. vim.env.PATH
end

require("config.lazy")
require("config.options")
require("config.keymaps")

