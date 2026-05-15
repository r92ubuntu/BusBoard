$mediaPath = Join-Path $PSScriptRoot "media"
$outputPath = Join-Path $mediaPath "ads.js"
$extensions = @(".jpg", ".jpeg", ".png", ".webp", ".gif", ".mp4", ".mov", ".webm")

if (-not (Test-Path -LiteralPath $mediaPath)) {
  New-Item -ItemType Directory -Force -Path $mediaPath | Out-Null
}

$files = Get-ChildItem -LiteralPath $mediaPath -File |
  Where-Object { $extensions -contains $_.Extension.ToLowerInvariant() } |
  Sort-Object Name |
  ForEach-Object { $_.Name }

$json = $files | ConvertTo-Json -Compress
if (-not $json) {
  $json = "[]"
}

Set-Content -LiteralPath $outputPath -Value "window.BusBoardAds = $json;" -Encoding UTF8
Write-Host "Generado $outputPath con $($files.Count) archivo(s)."
