$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Python = Join-Path $Root ".venv\Scripts\python.exe"
$Cloudflared = Join-Path $Root "tools\cloudflared.exe"
$CloudflaredUrl = "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe"

if (-not (Test-Path $Python)) {
    python -m venv (Join-Path $Root ".venv")
}

& $Python -m pip install -r (Join-Path $Root "busbuddy\requirements.txt")

if (-not (Test-Path $Cloudflared)) {
    New-Item -ItemType Directory -Force -Path (Join-Path $Root "tools") | Out-Null
    Invoke-WebRequest -Uri $CloudflaredUrl -OutFile $Cloudflared
}

Get-CimInstance Win32_Process |
    Where-Object {
        $_.ProcessId -ne $PID -and (
            $_.CommandLine -like "*manage.py runserver*" -or
            $_.CommandLine -like "*tools\cloudflared.exe*"
        )
    } |
    ForEach-Object {
        Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
    }

Start-Sleep -Seconds 2

Start-Process -FilePath $Python `
    -ArgumentList "manage.py", "runserver", "127.0.0.1:8000", "--noreload" `
    -WorkingDirectory (Join-Path $Root "busbuddy") `
    -WindowStyle Hidden

Start-Sleep -Seconds 4

$log = Join-Path $Root "cloudflared.err.log"
Remove-Item -ErrorAction SilentlyContinue $log

Start-Process -FilePath $Cloudflared `
    -ArgumentList "tunnel", "--url", "http://127.0.0.1:8000", "--no-autoupdate" `
    -WorkingDirectory $Root `
    -RedirectStandardError $log `
    -WindowStyle Hidden

Write-Host "Starting public tunnel..."
for ($i = 0; $i -lt 30; $i++) {
    Start-Sleep -Seconds 1
    if (Test-Path $log) {
        $match = Select-String -Path $log -Pattern "https://[-a-z0-9]+\.trycloudflare\.com" | Select-Object -First 1
        if ($match) {
            $url = $match.Matches[0].Value
            Write-Host ""
            Write-Host "BusBuddy is live at:"
            Write-Host $url
            Write-Host ""
            Write-Host "Keep this computer awake while sharing the link."
            exit 0
        }
    }
}

Write-Host "Tunnel started, but I could not detect the URL yet. Check cloudflared.err.log."
