param(
    [string]$nvimPath = "C:\neovim",
    [string]$configRepo = "https://github.com/IamPierrot/My-Neovim-Config.git",
    [string]$xdgBase = "$env:LOCALAPPDATA\nvim-data"
)

# Đặt XDG env
$env:XDG_CONFIG_HOME = Join-Path $xdgBase "config"
$env:XDG_DATA_HOME   = Join-Path $xdgBase "data"
$env:XDG_STATE_HOME  = Join-Path $xdgBase "state"
$env:XDG_CACHE_HOME  = Join-Path $xdgBase "cache"

$configPath = Join-Path $env:XDG_CONFIG_HOME "nvim"

Write-Host "=== Installing Neovim to $nvimPath ==="
Write-Host "Config: $configPath"
Write-Host "Data:   $env:XDG_DATA_HOME\nvim"

# Tạo folder XDG
New-Item -ItemType Directory -Force -Path $env:XDG_CONFIG_HOME | Out-Null
New-Item -ItemType Directory -Force -Path $env:XDG_DATA_HOME   | Out-Null
New-Item -ItemType Directory -Force -Path $env:XDG_STATE_HOME  | Out-Null
New-Item -ItemType Directory -Force -Path $env:XDG_CACHE_HOME  | Out-Null

# Cài Neovim
if (Get-Command winget -ErrorAction SilentlyContinue) {
    winget install Neovim.Neovim -y
} else {
    $zipUrl = "https://github.com/neovim/neovim/releases/latest/download/nvim-win64.zip"
    $zipFile = "$env:TEMP\nvim.zip"
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $nvimPath -Force
    Remove-Item $zipFile
}

# Cài Git
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    winget install Git.Git -y
}

# Clone config
if (Test-Path $configPath) {
    Remove-Item -Recurse -Force $configPath
}
git clone $configRepo $configPath

Write-Host "=== Done! Run nvim (with XDG vars set) ==="
