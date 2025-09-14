#!/usr/bin/env pwsh
# Execute an approved design document

param(
    [switch]$Json,
    [switch]$Help
)

if ($Help) {
    Write-Host "Usage: $($MyInvocation.MyCommand.Name) [-Json]"
    exit 0
}

$RepoRoot = git rev-parse --show-toplevel
$DesignsDir = Join-Path $RepoRoot "designs"

# Find the latest design file
if (-not (Test-Path $DesignsDir)) {
    Write-Error "ERROR: No designs directory found at $DesignsDir"
    exit 1
}

# Find the most recent design directory
$LatestDesignDir = Get-ChildItem -Path $DesignsDir -Directory | 
    Where-Object { $_.Name -match '^\d+_\d+_' } |
    Sort-Object Name -Descending | 
    Select-Object -First 1

if (-not $LatestDesignDir) {
    Write-Error "ERROR: No design documents found in $DesignsDir"
    exit 1
}

$DesignFile = Join-Path $LatestDesignDir.FullName "design.md"
if (-not (Test-Path $DesignFile)) {
    Write-Error "ERROR: Design file not found at $DesignFile"
    exit 1
}

# Extract design ID from directory name
$DesignId = ($LatestDesignDir.Name -split '_')[0..1] -join '_'

# Check if design is approved
$DesignContent = Get-Content $DesignFile -Raw
if ($DesignContent -notmatch '\*\*Status\*\*:\s*APPROVED') {
    Write-Warning "WARNING: Design document is not marked as APPROVED"
    Write-Warning "Please ensure the design has been reviewed and approved before executing."
}

# Create execution log
$ExecutionLog = Join-Path $LatestDesignDir.FullName "execution.log"
@"
Execution started at $(Get-Date)
Design ID: $DesignId
"@ | Set-Content -Path $ExecutionLog

if ($Json) {
    @{
        DESIGN_FILE = $DesignFile
        DESIGN_ID = $DesignId
        PROJECT_ROOT = $RepoRoot
    } | ConvertTo-Json -Compress
} else {
    Write-Host "DESIGN_FILE: $DesignFile"
    Write-Host "DESIGN_ID: $DesignId"
    Write-Host "PROJECT_ROOT: $RepoRoot"
}
