# --- SELF-ELEVATION BLOCK ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "[>] Requesting Administrator privileges..." -ForegroundColor Yellow
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Start-Process powershell -Verb RunAs -ArgumentList $arguments
    exit
}

# --- SETTINGS ---
$rarPath = "C:\Program Files\WinRAR\Rar.exe"
if (-not (Test-Path $rarPath)) {
    Write-Host "[!] ERROR: Rar.exe not found. Please install WinRAR." -ForegroundColor Red
    pause; exit
}

$targetDir = Read-Host "Paste the folder path"
$targetDir = $targetDir.Replace('"', '').Trim()

if (-not (Test-Path $targetDir)) {
    Write-Host "[!] ERROR: Folder does not exist." -ForegroundColor Red
    pause; exit
}

# --- KEYWORD MAP ---
$passMap = @{
    "DAISYCLOUD"  = "@UP_DAISYCLOUD"
    "VALENCIGA"   = "@VALENCIGA"
    "BRZCLOUD"    = "@POWERCLOUDMAIN"
    "evolution"   = "https://t.me/EvolutionLink_Chanel"
    "water"       = "@watercloud_info"
    "PIXEL"       = "@PIXELCLOUD2"
    "PIXELCLOUD3" = "@PIXELCLOUD3"
    "fate"        = "@fatetraffic"
}

# --- DISABLE DEFENDER ---
try {
    Write-Host "[>] Attempting to disable Defender..." -ForegroundColor Yellow
    Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction Stop
    Write-Host "[SUCCESS] Defender Real-Time Protection is OFF." -ForegroundColor Green
} catch {
    Write-Host "[!] Blocked: Tamper Protection is likely ON in Windows Settings." -ForegroundColor Cyan
    Write-Host "[>] Proceeding with extraction anyway..." -ForegroundColor Cyan
}

# --- EXTRACTION ---
Set-Location -LiteralPath $targetDir
$files = Get-ChildItem -Path . -File | Where-Object { $_.Extension -match "rar|zip" }
$total = $files.Count
$current = 0

Write-Host "`n[>] Starting extraction for $total archives..." -ForegroundColor White
echo ---------------------------------------------------------

foreach ($file in $files) {
    $current++
    $password = $null
    
    foreach ($key in $passMap.Keys) {
        if ($file.Name -like "*$key*") { 
            $password = $passMap[$key]
            break 
        }
    }

    if ($password) {
        Write-Host "[$current/$total] [EXTRACTING] $($file.Name)" -ForegroundColor Cyan
        
        # -inul: Total silence (required for millions of files)
        # -idp: Hide progress (better for performance)
        # --: Handles filenames starting with @
        & $rarPath x -ad -y -inul -idp "-p$password" -- "$($file.FullName)"
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host " -> [OK]" -ForegroundColor Green
        } else {
            Write-Host " -> [FAILED] Error Code: $LASTEXITCODE" -ForegroundColor Red
        }
    }
}

Write-Host "`n=== ALL TASKS COMPLETE ===" -ForegroundColor Green
pause
