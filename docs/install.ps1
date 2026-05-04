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
# Set $env:KUALI_VERSION (e.g. '1.0.0-rc14' or 'v1.0.0-rc14') to pin a version.
# Set $env:GITHUB_TOKEN to authenticate API calls (5000/hour vs 60/hour anonymous).
function Get-LatestVersion {
    if ($env:KUALI_VERSION) { return $env:KUALI_VERSION.TrimStart('v') }
    $headers = @{}
    if ($env:GITHUB_TOKEN) { $headers['Authorization'] = "Bearer $env:GITHUB_TOKEN" }
    $errors = @()
    try {
        $r = Invoke-RestMethod -UseBasicParsing -Headers $headers -Uri "https://api.github.com/repos/$Repo/releases/latest"
        if ($r.tag_name) { return $r.tag_name.TrimStart('v') }
    } catch {
        $errors += "releases/latest: $($_.Exception.Message)"
    }
    try {
        $all = Invoke-RestMethod -UseBasicParsing -Headers $headers -Uri "https://api.github.com/repos/$Repo/releases"
        if ($all -and $all[0].tag_name) { return $all[0].tag_name.TrimStart('v') }
    } catch {
        $errors += "releases: $($_.Exception.Message)"
    }
    $detail = if ($errors) { ' Underlying errors: ' + ($errors -join '; ') + '.' } else { '' }
    Write-Error "Failed to determine latest version from GitHub.$detail Set `$env:KUALI_VERSION to pin a specific tag, or see https://github.com/$Repo/releases."
}

$Version = Get-LatestVersion
$Url = "https://github.com/$Repo/releases/download/v$Version/$Binary-windows-$Arch.exe"

Write-Host "Downloading kuali v$Version for windows/$Arch..."
$Tmp = [System.IO.Path]::GetTempFileName() + '.exe'
try {
    Invoke-WebRequest -UseBasicParsing -Uri $Url -OutFile $Tmp
} catch {
    $hint = if ($env:KUALI_VERSION) {
        "Check that v$Version exists at https://github.com/$Repo/releases."
    } else {
        'See https://connector.kuali.co/installation/windows/ for manual steps.'
    }
    Write-Error "Download failed from $Url. $hint Underlying error: $($_.Exception.Message)"
}

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
# Move-Item -Force is unreliable when the destination exists on Windows; copy then
# delete the temp file so re-running the installer to upgrade works cleanly.
Copy-Item -Force -Path $Tmp -Destination $ExePath
Remove-Item -Force -Path $Tmp -ErrorAction SilentlyContinue
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
