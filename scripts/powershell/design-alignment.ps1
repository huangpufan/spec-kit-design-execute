#!/usr/bin/env pwsh
# Create a design document for comprehensive requirement alignment

param(
    [switch]$Json,
    [switch]$Help,
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Args
)

if ($Help) {
    Write-Host "Usage: $($MyInvocation.MyCommand.Name) [-Json] <requirement_description>"
    exit 0
}

$RequirementDescription = $Args -join ' '
if (-not $RequirementDescription) {
    Write-Error "Usage: $($MyInvocation.MyCommand.Name) [-Json] <requirement_description>"
    exit 1
}

$RepoRoot = git rev-parse --show-toplevel
$DesignsDir = Join-Path $RepoRoot "designs"
New-Item -ItemType Directory -Force -Path $DesignsDir | Out-Null

# Generate design ID based on timestamp
$DesignId = Get-Date -Format "yyyyMMdd_HHmmss"

# Create a sanitized name from the requirement
$DesignName = $RequirementDescription.ToLower() -replace '[^a-z0-9]', '-' -replace '-+', '-' -replace '^-|$-', ''
$Words = ($DesignName -split '-' | Where-Object { $_ } | Select-Object -First 5) -join '-'

# Create design directory
$DesignDir = Join-Path $DesignsDir "${DesignId}_${Words}"
New-Item -ItemType Directory -Force -Path $DesignDir | Out-Null

# Create design file
$DesignFile = Join-Path $DesignDir "design.md"

# Create initial design template
@"
# Design Document

**ID**: $DesignId
**Date**: $(Get-Date -Format "yyyy-MM-dd")
**Status**: DRAFT

## Requirement
$RequirementDescription

## Summary
<!-- Brief description of what will be done -->

## Context
<!-- Current state and why this change is needed -->

## Detailed Design
<!-- 
- Architecture decisions
- Component breakdown  
- Data flow and state management
- API changes (if any)
- Database schema changes (if any)
-->

## Implementation Plan
<!-- Step-by-step approach -->

## Testing Strategy
<!-- How to validate the implementation -->

## Risk Analysis
<!-- Potential issues and mitigation -->

## Alternatives Considered
<!-- Other approaches and why they were rejected -->

## Approval Status
<!-- DO NOT EDIT - Updated when design is approved -->
**Status**: PENDING
**Approved By**: -
**Approval Date**: -
"@ | Set-Content -Path $DesignFile

if ($Json) {
    @{
        PROJECT_ROOT = $RepoRoot
        DESIGN_DIR = $DesignDir
        DESIGN_FILE = $DesignFile
        DESIGN_ID = $DesignId
    } | ConvertTo-Json -Compress
} else {
    Write-Host "PROJECT_ROOT: $RepoRoot"
    Write-Host "DESIGN_DIR: $DesignDir"
    Write-Host "DESIGN_FILE: $DesignFile"
    Write-Host "DESIGN_ID: $DesignId"
}
