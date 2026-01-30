# Fix .bashrc encoding from UTF-16 to UTF-8 (no BOM)
$bashrcPath = "$env:USERPROFILE\.bashrc"
$bakPath = "$env:USERPROFILE\.bashrc.bak"
$tempPath = "$env:USERPROFILE\.bashrc.tmp"

if (Test-Path $bashrcPath) {
    # Read content with UTF-16 encoding
    $content = Get-Content -Path $bashrcPath -Encoding Unicode -Raw
    
    # Write with UTF-8 no BOM
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($tempPath, $content, $utf8NoBom)
    
    # Backup original
    Move-Item -Path $bashrcPath -Destination $bakPath -Force
    
    # Replace with fixed version
    Move-Item -Path $tempPath -Destination $bashrcPath -Force
    
    Write-Host "✅ Fixed .bashrc encoding (UTF-16 → UTF-8)" -ForegroundColor Green
    Write-Host "   Backup saved to: $bakPath" -ForegroundColor Cyan
} else {
    Write-Host "⚠️ .bashrc not found at $bashrcPath" -ForegroundColor Yellow
}
