# Install on Windows

The Connector supports **Windows 10 and Windows 11** on both amd64 and arm64.

## Option 1: PowerShell installer (recommended)

Open **PowerShell** and run:

```powershell
irm https://connector.kuali.co/install.ps1 | iex
```

The script picks the right build for your CPU (amd64 or arm64), downloads it to `%LOCALAPPDATA%\Programs\kuali\kuali.exe`, and adds that folder to your user `PATH`. No admin rights required.

Open a **new** PowerShell window when it finishes so the updated `PATH` takes effect.

## Option 2: Direct download

1. Open the [latest release](https://github.com/kualico/kuali-connector/releases/latest).
2. Download `kuali-windows-amd64.exe` (most PCs) or `kuali-windows-arm64.exe` (Copilot+ PCs and other ARM machines).
3. Rename the file to `kuali.exe`.
4. Move it to a folder on your `PATH`. A common choice is `%LOCALAPPDATA%\Programs\kuali\`:

    ```powershell
    $dir = "$env:LOCALAPPDATA\Programs\kuali"
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    Move-Item -Force "$HOME\Downloads\kuali-windows-amd64.exe" "$dir\kuali.exe"
    ```

5. Add that folder to your user `PATH` if it isn't there already:

    ```powershell
    [Environment]::SetEnvironmentVariable(
      "PATH",
      "$env:PATH;$env:LOCALAPPDATA\Programs\kuali",
      "User"
    )
    ```

    Open a **new** PowerShell window so the updated `PATH` takes effect.

## Option 3: WSL

If you use Windows Subsystem for Linux, install the Linux build inside your WSL distro — see the [Linux guide](linux.md). An AI client running on Windows can still call a Connector installed in WSL if you point the MCP config at the WSL binary path (`\\wsl$\Ubuntu\home\you\.local\bin\kuali`).

## First-launch approval

Windows SmartScreen may warn the first time you run an unsigned executable.

!!! warning "If you see *"Windows protected your PC"*"
    Click **More info**, then **Run anyway**. You'll only see this once per machine.

## Verify

```powershell
kuali version
```

If the command isn't found, `PATH` likely didn't pick up the new folder — close and reopen PowerShell, or sign out and back in.

## Uninstall

```powershell
Remove-Item "$env:LOCALAPPDATA\Programs\kuali" -Recurse -Force
Remove-Item "$HOME\.kuali" -Recurse -Force
```

To remove the directory from your `PATH`, open **Settings → System → About → Advanced system settings → Environment Variables**, find `Path` under *User variables*, edit, and remove the `…\Programs\kuali` entry.

If you stored API keys in Windows Credential Manager (via `kuali auth login`), open **Credential Manager → Windows Credentials** and delete the entries under the `kuali-cli` service.
