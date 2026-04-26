#Requires -Version 5.1
$ErrorActionPreference = 'Stop'

$Repo     = 'KualiCo/kuali-connector'
$Binary   = 'kuali'
$InstallDir = Join-Path $env:LOCALAPPDATA 'Programs\kuali'
$ExePath  = Join-Path $InstallDir "$Binary.exe"

# Windows PowerShell 5.1 defaults to TLS 1.0/1.1, which GitHub rejects.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

switch ($env:PROCESSOR_ARCHITECTURE) {
    'AMD64' { $Arch = 'amd64' }
    'ARM64' { $Arch = 'arm64' }
    default {
        Write-Error "Unsupported architecture: $env:PROCESSOR_ARCHITECTURE. See https://connector.kuali.co/installation/windows/ for manual steps."
    }
}

# Prefer the latest stable release; fall back to the most recent published
# release (including prereleases) so installs work during the RC phase.
function Get-LatestVersion {
    try {
        $r = Invoke-RestMethod -UseBasicParsing -Uri "https://api.github.com/repos/$Repo/releases/latest"
        if ($r.tag_name) { return $r.tag_name.TrimStart('v') }
    } catch { }
    try {
        $all = Invoke-RestMethod -UseBasicParsing -Uri "https://api.github.com/repos/$Repo/releases"
        if ($all -and $all[0].tag_name) { return $all[0].tag_name.TrimStart('v') }
    } catch { }
    Write-Error 'Failed to determine latest version from GitHub.'
}

$Version = Get-LatestVersion
$Url = "https://github.com/$Repo/releases/download/v$Version/$Binary-windows-$Arch.exe"

Write-Host "Downloading kuali v$Version for windows/$Arch..."
$Tmp = [System.IO.Path]::GetTempFileName() + '.exe'
try {
    Invoke-WebRequest -UseBasicParsing -Uri $Url -OutFile $Tmp
} catch {
    Write-Error "Download failed from $Url. See https://connector.kuali.co/installation/windows/ for manual steps. Underlying error: $($_.Exception.Message)"
}

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
Move-Item -Force -Path $Tmp -Destination $ExePath
Unblock-File -Path $ExePath

$UserPath = [Environment]::GetEnvironmentVariable('PATH', 'User')
$Parts = @()
if ($UserPath) { $Parts = $UserPath.Split(';') }
if (-not ($Parts | Where-Object { $_.TrimEnd('\') -ieq $InstallDir.TrimEnd('\') })) {
    $NewPath = if ($UserPath) { "$UserPath;$InstallDir" } else { $InstallDir }
    [Environment]::SetEnvironmentVariable('PATH', $NewPath, 'User')
    $PathUpdated = $true
} else {
    $PathUpdated = $false
}
# Also update current session so `kuali version` works without reopening.
if (-not ($env:PATH.Split(';') | Where-Object { $_.TrimEnd('\') -ieq $InstallDir.TrimEnd('\') })) {
    $env:PATH = "$env:PATH;$InstallDir"
}

Write-Host ''
Write-Host "kuali v$Version installed to $ExePath"
if ($PathUpdated) {
    Write-Host 'Added install directory to your user PATH. Open a new PowerShell window so other shells pick it up.'
}
Write-Host ''
Write-Host 'Next steps:'
Write-Host '  1. Run: kuali setup                              # connect to your Kuali instance'
Write-Host '  2. Run: kuali mcp setup --client <your-ai-tool>  # wire up Claude, Cursor, etc.'
Write-Host '  3. Restart your AI tool'
