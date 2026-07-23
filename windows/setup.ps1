# =============================================================================
#  Windows Setup Script for dotfiles
#  WSL上のNeovimをWindows側から利用するための設定 +
#  Windows版 WezTerm (WSL/NixOS への mux 接続) の設定配置
# =============================================================================

param(
    # dotfiles の windows ディレクトリの Windows パス。WSL から実行する場合は
    #   -DotfilesWinDir "$(wslpath -w ~/dotfiles/windows)"
    # のように渡す。省略時はスクリプト自身の場所から自動解決を試みる。
    [string]$DotfilesWinDir = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Windows Dotfiles Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# dotfilesディレクトリの解決
#   引数 > $PSScriptRoot > $PSCommandPath の順にフォールバック。
#   UNCパス経由や古い PowerShell では自動変数が未定義のことがあるため、
#   StrictMode 下でも安全に読める Get-Variable で取得する。
if ([string]::IsNullOrEmpty($DotfilesWinDir)) {
    $DotfilesWinDir = Get-Variable -Name PSScriptRoot -ValueOnly -ErrorAction SilentlyContinue
}
if ([string]::IsNullOrEmpty($DotfilesWinDir)) {
    $cmdPath = Get-Variable -Name PSCommandPath -ValueOnly -ErrorAction SilentlyContinue
    if (-not [string]::IsNullOrEmpty($cmdPath)) {
        $DotfilesWinDir = Split-Path -Parent $cmdPath
    }
}
if ([string]::IsNullOrEmpty($DotfilesWinDir) -or -not (Test-Path $DotfilesWinDir)) {
    Write-Host "ERROR: dotfiles の windows ディレクトリを特定できませんでした。" -ForegroundColor Red
    Write-Host "  次のように -DotfilesWinDir を指定して再実行してください:" -ForegroundColor Red
    Write-Host '    ... setup.ps1 -DotfilesWinDir "$(wslpath -w ~/dotfiles/windows)"' -ForegroundColor Red
    exit 1
}
$BinDir = Join-Path $env:USERPROFILE "bin"

# =============================================================================
# 1. ~/bin ディレクトリ作成
# =============================================================================
Write-Host "[1/4] Setting up ~/bin directory..." -ForegroundColor Yellow

if (!(Test-Path $BinDir)) {
    New-Item -ItemType Directory -Path $BinDir | Out-Null
    Write-Host "  Created $BinDir"
} else {
    Write-Host "  $BinDir already exists"
}

# =============================================================================
# 2. nvim.bat を ~/bin にコピー
# =============================================================================
Write-Host "[2/4] Installing nvim.bat..." -ForegroundColor Yellow

$Source = Join-Path $DotfilesWinDir "nvim.bat"
$Target = Join-Path $BinDir "nvim.bat"

Copy-Item -Path $Source -Destination $Target -Force
Write-Host "  Copied nvim.bat -> $Target"

# =============================================================================
# 3. WezTerm 設定を %USERPROFILE%\.wezterm.lua にコピー
#    (シンボリックリンクは開発者モード/管理者権限が必要なためコピー方式。
#     .wezterm.lua を直接編集した場合は windows/wezterm.lua へ反映すること)
# =============================================================================
Write-Host "[3/4] Installing wezterm config..." -ForegroundColor Yellow

$WeztermSource = Join-Path $DotfilesWinDir "wezterm.lua"
$WeztermTarget = Join-Path $env:USERPROFILE ".wezterm.lua"

Copy-Item -Path $WeztermSource -Destination $WeztermTarget -Force
Write-Host "  Copied wezterm.lua -> $WeztermTarget"

# =============================================================================
# 4. 環境変数の設定
# =============================================================================
Write-Host "[4/4] Configuring environment variables..." -ForegroundColor Yellow

# PATH に ~/bin を追加
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -split ";" -notcontains $BinDir) {
    [Environment]::SetEnvironmentVariable("Path", "$UserPath;$BinDir", "User")
    Write-Host "  Added $BinDir to PATH"
} else {
    Write-Host "  $BinDir already in PATH"
}

# EDITOR 環境変数の設定
$CurrentEditor = [Environment]::GetEnvironmentVariable("EDITOR", "User")
if ($CurrentEditor -ne $Target) {
    [Environment]::SetEnvironmentVariable("EDITOR", $Target, "User")
    Write-Host "  Set EDITOR=$Target"
} else {
    Write-Host "  EDITOR already set"
}

# =============================================================================
# 完了
# =============================================================================
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Changes:" -ForegroundColor Cyan
Write-Host "  - nvim.bat installed to $Target"
Write-Host "  - wezterm.lua installed to $WeztermTarget"
Write-Host "  - $BinDir added to user PATH"
Write-Host "  - EDITOR set to nvim.bat"
Write-Host ""
Write-Host "NOTE: Restart your terminal for PATH changes to take effect." -ForegroundColor Yellow
Write-Host ""
Write-Host "Optional - set as Git editor:" -ForegroundColor Cyan
Write-Host "  git config --global core.editor `"$($Target -replace '\\','/')`""
Write-Host ""
