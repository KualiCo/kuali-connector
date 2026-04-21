# Install on Windows

The Connector supports **Windows 10 and Windows 11**, 64-bit.

## Option 1: PowerShell installer (recommended)

Open **PowerShell** (press ++win++, type `PowerShell`, press ++enter++) and paste:

```powershell
iwr -useb https://kualico.github.io/kuali-connector/install.ps1 | iex
```

The installer will download the latest Connector and put it somewhere on your PATH. Close and reopen PowerShell, then verify:

```powershell
kuali --version
```

## Option 2: Winget

If you have [Windows Package Manager](https://learn.microsoft.com/en-us/windows/package-manager/):

```powershell
winget install Kuali.Connector
```

## Option 3: Manual download

1. Go to the [latest release](https://github.com/kualico/kuali-connector/releases/latest).
2. Download the file ending in `-windows-amd64.zip`.
3. Right-click the downloaded file → **Extract All...**
4. Copy `kuali.exe` somewhere permanent, such as `C:\Program Files\Kuali\`.
5. Add that folder to your PATH:

    - Press ++win++ and type "environment variables"
    - Click **Edit the system environment variables**
    - Click **Environment Variables...**
    - Under **User variables**, select `Path` and click **Edit**
    - Click **New** and paste `C:\Program Files\Kuali\`
    - Click **OK** on all dialogs

6. Close and reopen PowerShell, then run `kuali --version` to verify.

## SmartScreen warning

The first time you run `kuali.exe`, Windows SmartScreen may show a warning that the file is from an unknown publisher. If that happens:

1. Click **More info**
2. Click **Run anyway**

Your campus IT department may block this. If so, contact them about getting the Kuali Connector approved.

## Uninstall

1. Delete the `kuali.exe` file from wherever you installed it
2. Remove it from your PATH (reverse the steps above)
3. Delete `%USERPROFILE%\.config\kuali` to remove saved credentials and config
