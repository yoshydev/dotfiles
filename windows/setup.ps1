# =============================================================================
#  Windows Setup Script for dotfiles
#  WSL上のNeovimをWindows側から利用するための設定
# =============================================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Windows Dotfiles Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# dotfilesディレクトリの取得（このスクリプトの親ディレクトリ）
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DotfilesWinDir = $ScriptDir
$BinDir = Join-Path $env:USERPROFILE "bin"

# =============================================================================
# 1. ~/bin ディレクトリ作成
# =============================================================================
Write-Host "[1/3] Setting up ~/bin directory..." -ForegroundColor Yellow

if (!(Test-Path $BinDir)) {
    New-Item -ItemType Directory -Path $BinDir | Out-Null
    Write-Host "  Created $BinDir"
} else {
    Write-Host "  $BinDir already exists"
}

# =============================================================================
# 2. nvim.bat を ~/bin にコピー
# =============================================================================
Write-Host "[2/3] Installing nvim.bat..." -ForegroundColor Yellow

$Source = Join-Path $DotfilesWinDir "nvim.bat"
$Target = Join-Path $BinDir "nvim.bat"

Copy-Item -Path $Source -Destination $Target -Force
Write-Host "  Copied nvim.bat -> $Target"

# =============================================================================
# 3. 環境変数の設定
# =============================================================================
Write-Host "[3/3] Configuring environment variables..." -ForegroundColor Yellow

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
Write-Host "  - $BinDir added to user PATH"
Write-Host "  - EDITOR set to nvim.bat"
Write-Host ""
Write-Host "NOTE: Restart your terminal for PATH changes to take effect." -ForegroundColor Yellow
Write-Host ""
Write-Host "Optional - set as Git editor:" -ForegroundColor Cyan
Write-Host "  git config --global core.editor `"$($Target -replace '\\','/')`""
Write-Host ""
