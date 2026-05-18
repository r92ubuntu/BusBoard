$mediaPath = Join-Path $PSScriptRoot "media"
$assetsPath = Join-Path $PSScriptRoot "pantalla"
$outputPath = Join-Path $assetsPath "lista.js"
$extensions = @(".jpg", ".jpeg", ".png", ".webp", ".gif", ".mp4", ".mov", ".webm")

if (-not (Test-Path -LiteralPath $mediaPath)) {
  New-Item -ItemType Directory -Force -Path $mediaPath | Out-Null
}

if (-not (Test-Path -LiteralPath $assetsPath)) {
  New-Item -ItemType Directory -Force -Path $assetsPath | Out-Null
}

function ConvertTo-StationKey($value) {
  $normalized = $value.Normalize([Text.NormalizationForm]::FormD)
  $builder = New-Object Text.StringBuilder
  foreach ($char in $normalized.ToCharArray()) {
    if ([Globalization.CharUnicodeInfo]::GetUnicodeCategory($char) -ne [Globalization.UnicodeCategory]::NonSpacingMark) {
      [void]$builder.Append($char)
    }
  }

  return ($builder.ToString().ToLowerInvariant() -replace '[^a-z0-9]', '')
}

$knownStations = @{
  "comayagua" = "Comayagua"
  "laesperanza" = "La Esperanza"
  "lapaz" = "La Paz"
  "mancala" = "Marcala"
  "marcala" = "Marcala"
  "sanpedrosula" = "San Pedro Sula"
  "sampedrosula" = "San Pedro Sula"
}

function Get-StationFromFileName($baseName) {
  $key = ConvertTo-StationKey ($baseName -replace '\d+$', '')
  foreach ($stationKey in ($knownStations.Keys | Sort-Object Length -Descending)) {
    if ($key.StartsWith($stationKey)) {
      return $knownStations[$stationKey]
    }
  }

  return $null
}

$files = Get-ChildItem -LiteralPath $mediaPath -File |
  Where-Object { $extensions -contains $_.Extension.ToLowerInvariant() } |
  Sort-Object Name |
  ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $assetsPath $_.Name) -Force
    $station = Get-StationFromFileName $_.BaseName
    $item = [ordered]@{
      file = $_.Name
      title = $_.BaseName
    }
    if ($station) {
      $item.station = $station
    }
    [PSCustomObject]$item
  }

$json = $files | ConvertTo-Json -Compress
if (-not $json) {
  $json = "[]"
}

Set-Content -LiteralPath $outputPath -Value "window.BusBoardPantallaLista = $json;" -Encoding UTF8
Write-Host "Generado $outputPath con $($files.Count) archivo(s)."
