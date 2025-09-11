param(
    [string]$nvimPath = "C:\Program Files\neovim",
    [string]$xdgBase = "C:\Program Files\neovim\nvim-data"
)

$configRepo = "https://github.com/IamPierrot/My-Neovim-Config.git"

# Đặt XDG env

# Set XDG env cho session hiện tại
$env:XDG_CONFIG_HOME = Join-Path $xdgBase "config"
$env:XDG_DATA_HOME = Join-Path $xdgBase "data"
$env:XDG_STATE_HOME = Join-Path $xdgBase "state"
$env:XDG_CACHE_HOME = Join-Path $xdgBase "cache"

# Set XDG env vĩnh viễn cho user
[Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", $env:XDG_CONFIG_HOME, "User")
[Environment]::SetEnvironmentVariable("XDG_DATA_HOME", $env:XDG_DATA_HOME, "User")
[Environment]::SetEnvironmentVariable("XDG_STATE_HOME", $env:XDG_STATE_HOME, "User")
[Environment]::SetEnvironmentVariable("XDG_CACHE_HOME", $env:XDG_CACHE_HOME, "User")

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
$zipUrl = "https://github.com/neovim/neovim/releases/latest/download/nvim-win64.zip"
$zipFile = "$env:TEMP\nvim.zip"
Invoke-WebRequest -Uri $zipUrl -OutFile $zipFile
Expand-Archive -Path $zipFile -DestinationPath $nvimPath -Force
Remove-Item $zipFile
# Nếu giải nén, nvim.exe nằm trong $nvimPath\nvim-win64\bin
$nvimBinPath = Join-Path $nvimPath "nvim-win64\bin"


# Thêm Neovim vào PATH nếu chưa có
if ($env:PATH -notlike "*${nvimBinPath}*") {
    Write-Host "Adding $nvimBinPath to PATH (current session)"
    $env:PATH = "$nvimBinPath;" + $env:PATH
    # Thêm vào PATH user (vĩnh viễn)
    [Environment]::SetEnvironmentVariable("PATH", "$nvimBinPath;" + [Environment]::GetEnvironmentVariable("PATH", "User"), "User")
}

# Cài Git
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    winget install Git.Git
}

# Clone config
if (Test-Path $configPath) {
    Remove-Item -Recurse -Force $configPath
}
git clone $configRepo $configPath

Write-Host "=== Done! Run nvim (with XDG vars set) ==="
Write-Host "You may need to restart your terminal or log out/in for PATH changes to take effect."
