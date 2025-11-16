<#
PowerShell script to download Bootstrap and Font Awesome into ./assets for offline use.
Run: .\download-assets.ps1
#>

$assetsDir = Join-Path -Path $PSScriptRoot -ChildPath 'assets'
$cssDir = Join-Path $assetsDir 'css'
$jsDir = Join-Path $assetsDir 'js'
$fontsDir = Join-Path $assetsDir 'webfonts'

New-Item -ItemType Directory -Force -Path $cssDir, $jsDir, $fontsDir | Out-Null

Write-Host 'Downloading Bootstrap...'
$bootstrapCss = 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css'
$bootstrapJs = 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js'

Invoke-WebRequest -Uri $bootstrapCss -OutFile (Join-Path $cssDir 'bootstrap.min.css') -UseBasicParsing
Invoke-WebRequest -Uri $bootstrapJs -OutFile (Join-Path $jsDir 'bootstrap.bundle.min.js') -UseBasicParsing

Write-Host 'Downloading Font Awesome via npm (temporary)...'
# Use npm to fetch the package and extract dist files
$tmp = New-Item -ItemType Directory -Path (Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString()))
Push-Location $tmp.FullName

npm pack @fortawesome/fontawesome-free@6.4.0 | Out-Null
$targz = Get-ChildItem -Filter '*.tgz' | Select-Object -First 1
if (-not $targz) { Write-Error 'npm pack failed to download fontawesome'; Pop-Location; exit 1 }

# Extract tarball (tar is available on modern Windows or in Git Bash)
# Use tar if present
if (Get-Command tar -ErrorAction SilentlyContinue) {
    tar -xzf $targz.FullName -C .
} else {
    Write-Error 'tar not found. Please run this script in an environment with tar (Git Bash / WSL / Windows 10+).'
    Pop-Location
    exit 1
}

Copy-Item -Path 'package/dist/css/all.min.css' -Destination (Join-Path $cssDir 'fontawesome.min.css') -Force
Copy-Item -Path 'package/dist/webfonts/*' -Destination $fontsDir -Recurse -Force

Pop-Location
Remove-Item -Recurse -Force $tmp.FullName

Write-Host 'Done. Local assets saved under .\assets\'