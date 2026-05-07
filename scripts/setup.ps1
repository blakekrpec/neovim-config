# setup.ps1 - Windows setup for blakekrpec/neovim-config
# Run this after cloning the repo to install all required dependencies.
# See docs/ for details on what some of the steps are doing and why.
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File scripts\setup.ps1
#   powershell -ExecutionPolicy Bypass -File scripts\setup.ps1 -InstallVstuc
#   powershell -ExecutionPolicy Bypass -File scripts\setup.ps1 -NoFonts

param(
    [switch]$InstallVstuc,
    [switch]$NoFonts
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.IO.Compression.FileSystem

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
function Write-Header([string]$Msg) { Write-Host "`n==> $Msg" -ForegroundColor White }
function Write-Info([string]$Msg)   { Write-Host "[INFO]  $Msg" -ForegroundColor Cyan }
function Write-Ok([string]$Msg)     { Write-Host "[OK]    $Msg" -ForegroundColor Green }
function Write-Warn([string]$Msg)   { Write-Host "[WARN]  $Msg" -ForegroundColor Yellow }
function Test-Cmd([string]$Name)    { [bool](Get-Command $Name -ErrorAction SilentlyContinue) }

function Refresh-Path {
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("PATH", "User")
}

# ---------------------------------------------------------------------------
# 1. Neovim (stable) - downloaded directly from GitHub releases
# ---------------------------------------------------------------------------
Write-Header "Installing Neovim (stable)"
# Download from GitHub stable release to guarantee 0.10+ rather than
# relying on whatever version a package manager happens to have.
if (Test-Cmd "nvim") {
    Write-Ok "nvim already installed: $(nvim --version | Select-Object -First 1)"
} else {
    $nvimZip    = Join-Path $env:TEMP "nvim-win64.zip"
    $nvimParent = "$env:LOCALAPPDATA\nvim-app"
    $nvimBin    = "$nvimParent\nvim-win64\bin"

    Write-Info "Downloading Neovim (stable release)..."
    Invoke-WebRequest `
        -Uri "https://github.com/neovim/neovim/releases/download/stable/nvim-win64.zip" `
        -OutFile $nvimZip

    Write-Info "Extracting Neovim to $nvimParent..."
    New-Item -ItemType Directory -Force -Path $nvimParent | Out-Null
    Expand-Archive -Path $nvimZip -DestinationPath $nvimParent -Force
    Remove-Item $nvimZip

    # Persist bin directory in user PATH
    $userPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
    if ($userPath -notlike "*$nvimBin*") {
        [System.Environment]::SetEnvironmentVariable("PATH", "$userPath;$nvimBin", "User")
    }
    $env:PATH += ";$nvimBin"

    Write-Ok "nvim installed: $(nvim --version | Select-Object -First 1)"
}

# ---------------------------------------------------------------------------
# 2. Node.js v22+ (required by copilot.lua)
# ---------------------------------------------------------------------------
Write-Header "Installing Node.js v22+"
# docs/NODEJS_COPILOT.md - copilot.lua requires Node.js v22 or newer.
$nodeOk = $false
if (Test-Cmd "node") {
    $nodeVer = node --version 2>$null
    $nodeMajor = [int]($nodeVer -replace 'v(\d+).*', '$1')
    if ($nodeMajor -ge 22) {
        Write-Ok "Node.js $nodeVer already satisfies v22+ requirement"
        $nodeOk = $true
    } else {
        Write-Info "Node.js $nodeVer is older than v22 - upgrading..."
    }
}

if (-not $nodeOk) {
    if (Test-Cmd "winget") {
        winget install --id OpenJS.NodeJS.LTS --source winget --silent `
            --accept-package-agreements --accept-source-agreements
        Refresh-Path
        Write-Ok "Node.js installed: $(node --version 2>$null)"
    } else {
        Write-Warn "winget not found - install Node.js v22+ manually from https://nodejs.org"
    }
}

# ---------------------------------------------------------------------------
# 3. Claude Code CLI (required by lua/plugins/claude-code.lua)
# ---------------------------------------------------------------------------
Write-Header "Installing Claude Code CLI"
# docs/CLAUDE_CODE.md - claudecode.nvim connects to the 'claude' CLI over the
# official IDE extension protocol. On first run inside nvim, 'claude' will
# prompt for auth (browser OAuth or ANTHROPIC_API_KEY). Credentials are
# stored under ~/.claude/ and never touch this repo.
if (Test-Cmd "claude") {
    Write-Ok "claude already installed: $(claude --version 2>$null | Select-Object -First 1)"
} else {
    if (Test-Cmd "npm") {
        npm install -g @anthropic-ai/claude-code
        Write-Ok "claude installed"
    } else {
        Write-Warn "npm not found - skipping claude install. Re-run after Node.js is on PATH."
    }
}

# ---------------------------------------------------------------------------
# 4. Nerd Font (0xProto) - used for fancy icons in nvim
# ---------------------------------------------------------------------------
Write-Header "Installing 0xProto Nerd Font"
# docs/NERD_FONT.md - without a Nerd Font the icons appear as ? diamonds.
if ($NoFonts) {
    Write-Info "Skipping Nerd Font install (-NoFonts)"
} else {
    $fontDir  = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
    $regPath  = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    $sentinel = Join-Path $fontDir "0xProtoNerdFont-Regular.ttf"

    if (Test-Path $sentinel) {
        Write-Ok "0xProto Nerd Font already installed"
    } else {
        $tmpDir  = Join-Path $env:TEMP "0xProtoFont"
        $tarPath = Join-Path $tmpDir "0xProto.tar.xz"
        New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null

        Write-Info "Downloading 0xProto Nerd Font..."
        Invoke-WebRequest `
            -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/0xProto.tar.xz" `
            -OutFile $tarPath

        Write-Info "Extracting font archive..."
        # tar.exe ships with Windows 10 1803+ and handles .tar.xz natively
        & tar -xf $tarPath -C $tmpDir

        New-Item -ItemType Directory -Force -Path $fontDir | Out-Null
        foreach ($font in (Get-ChildItem $tmpDir -Filter "*.ttf")) {
            Copy-Item -Path $font.FullName -Destination $fontDir -Force
            # Register font at user scope (no admin required)
            Set-ItemProperty -Path $regPath `
                -Name "$($font.BaseName) (TrueType)" -Value $font.Name -Force
        }

        Remove-Item -Recurse -Force $tmpDir
        Write-Ok "0xProto Nerd Font installed to $fontDir"
        Write-Warn "Restart your terminal and set the font to '0xProto Nerd Font' in terminal preferences"
    }
}

# ---------------------------------------------------------------------------
# 5. vstuc dlls - only installed when -InstallVstuc flag is passed
# ---------------------------------------------------------------------------
Write-Header "Unity Debugging: vstuc dlls"
# docs/UNITY_DEBUG.md - nvim-dap Unity debugging requires two dlls from vstuc.
# Pass -InstallVstuc to enable (e.g. on a Unity dev machine).
if ($env:XDG_DATA_HOME) {
    $nvimData = $env:XDG_DATA_HOME
} else {
    $nvimData = "$env:LOCALAPPDATA\nvim-data"
}
$vstucDir = Join-Path $nvimData "vstuc"

if ($InstallVstuc) {
    # .NET SDK (required by OmniSharp — docs/UNITY_OMNISHARP.md)
    $dotnetOk = $false
    # Run in a child scope so NativeCommandError from a broken/missing dotnet
    # doesn't trip $ErrorActionPreference = 'Stop' in PS 5.1.
    $dotnetVer = & { $ErrorActionPreference = 'SilentlyContinue'; dotnet --version 2>&1 | Select-Object -First 1 }
    $dotnetMajor = ($dotnetVer -replace '^(\d+)\..*', '$1') -as [int]
    if ($dotnetMajor -ge 8) {
        Write-Ok ".NET SDK $dotnetVer already satisfies v8+ requirement"
        $dotnetOk = $true
    }
    if (-not $dotnetOk) {
        Write-Info "Installing .NET SDK 10..."
        if (Test-Cmd "winget") {
            winget install --id Microsoft.DotNet.SDK.10 --source winget --silent `
                --accept-package-agreements --accept-source-agreements
            Refresh-Path
            if (Test-Cmd "dotnet") {
                Write-Ok ".NET SDK installed: $(dotnet --version 2>$null)"
            } else {
                Write-Warn ".NET SDK installed - restart your terminal for 'dotnet' to appear on PATH"
            }
        } else {
            Write-Warn "winget not found - install .NET SDK 10+ manually from https://aka.ms/dotnet/download"
        }
    }

    if (Test-Path $vstucDir) {
        Write-Ok "vstuc already present at $vstucDir"
    } else {
        New-Item -ItemType Directory -Force -Path $nvimData | Out-Null
        $zipPath = Join-Path $nvimData "vstuc.zip"

        Write-Info "Downloading vstuc..."
        Invoke-WebRequest `
            -Uri "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/VisualStudioToolsForUnity/vsextensions/vstuc/1.1.0/vspackage" `
            -OutFile $zipPath

        Write-Info "Extracting vstuc..."
        Expand-Archive -Path $zipPath -DestinationPath $vstucDir -Force
        Remove-Item $zipPath
        Write-Ok "vstuc extracted to $vstucDir"
    }
} else {
    Write-Info "Skipping vstuc (pass -InstallVstuc to enable)"
}

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "Setup complete!" -ForegroundColor Green
Write-Host ""
