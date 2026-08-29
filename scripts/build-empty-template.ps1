$ErrorActionPreference = "Stop"

$repo = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repo "templates\gwo-empty-content-pack"
$output = Join-Path $repo "docs\.vuepress\public\downloads\gwo_empty_content_pack_template.zip"
$stageRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("gwo-empty-template-" + [guid]::NewGuid())
$stage = Join-Path $stageRoot "gwo_empty_content_pack"

try {
    New-Item -ItemType Directory -Path $stage -Force | Out-Null
    Copy-Item -Path (Join-Path $source "*") -Destination $stage -Recurse -Force
    if (Test-Path -LiteralPath $output) {
        Remove-Item -LiteralPath $output -Force
    }
    Compress-Archive -Path (Join-Path $stage "*") -DestinationPath $output -CompressionLevel Optimal
    Write-Host "Built $output"
}
finally {
    if (Test-Path -LiteralPath $stageRoot) {
        Remove-Item -LiteralPath $stageRoot -Recurse -Force
    }
}
