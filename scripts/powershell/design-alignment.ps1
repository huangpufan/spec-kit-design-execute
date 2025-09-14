#!/usr/bin/env pwsh
# Create a design document for comprehensive requirement alignment (language-aware, KISS)

param(
    [switch]$Json,
    [switch]$Help,
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Args
)

if ($Help) {
    Write-Host "Usage: $($MyInvocation.MyCommand.Name) [-Json] <slug_or_requirement>"
    exit 0
}

$InputText = $Args -join ' '
if (-not $InputText) {
    Write-Error "Usage: $($MyInvocation.MyCommand.Name) [-Json] <slug_or_requirement>"
    exit 1
}

$RepoRoot = git rev-parse --show-toplevel
$DesignsDir = Join-Path $RepoRoot "designs"
New-Item -ItemType Directory -Force -Path $DesignsDir | Out-Null

# Detect language configuration (default: en)
$Language = 'en'
$LangConf = Join-Path $RepoRoot '.specify/config/language.conf'
if (Test-Path $LangConf) {
    $line = (Select-String -Path $LangConf -Pattern '^LANGUAGE=' -Raw -ErrorAction SilentlyContinue)
    if ($line) {
        $Language = (($line -replace '^LANGUAGE=', '')).Trim()
    }
}

# Generate design ID based on timestamp
$DesignId = Get-Date -Format "yyyyMMdd_HHmmss"

# Generate a kebab-case ASCII slug (fallback-safe)
function New-Slug([string]$text) {
    $normalized = $text.Normalize([Text.NormalizationForm]::FormKD)
    $bytes = [Text.Encoding]::GetEncoding("us-ascii",[Text.EncoderFallback]::ReplacementFallback,[Text.DecoderFallback]::ReplacementFallback).GetBytes($normalized)
    $ascii = [Text.Encoding]::ASCII.GetString($bytes)
    $slug = ($ascii -replace '[^a-zA-Z0-9]+','-').Trim('-').ToLower()
    $parts = $slug -split '-' | Where-Object { $_ }
    return ($parts | Select-Object -First 5) -join '-'
}

$Slug = New-Slug $InputText
if (-not $Slug) { $Slug = 'design' }

# Create design directory
$DesignDir = Join-Path $DesignsDir "${DesignId}_${Slug}"
New-Item -ItemType Directory -Force -Path $DesignDir | Out-Null

# Create design file
$DesignFile = Join-Path $DesignDir "design.md"
$Date = Get-Date -Format "yyyy-MM-dd"

if ($Language -eq 'zh') {
@"
# 设计文档

**ID**: $DesignId
**Date**: $Date
**Status**: DRAFT

## 需求描述
<!-- 在设计对齐后由助手填写需求与范围 -->

## 概要说明
<!-- 清晰、简洁地说明要做什么，以及为什么要做 -->

## 背景分析
<!-- 当前状态与变更原因（关联模块、现状问题、动机） -->

## 设计原则
- **KISS 原则**：保持简单，避免过度设计
- **简单优先**：优先采用直接、可维护的方案
- **避免过早优化**：不引入不必要的复杂度

## 详细设计
<!-- 
- 架构决策（尽量保持简单）
- 组件分解（控制颗粒度）
- 数据流与状态管理（选择最简单可行方式）
- API 变更（如有，保持接口最小与干净）
- 数据库变更（如有，避免不必要复杂度）
-->

## 实施计划
<!-- 步骤化计划，按最小化改动与可回滚性排序 -->

## 测试策略
<!-- 关注关键路径与必要用例，避免过度测试 -->

## 风险分析
<!-- 潜在问题与缓解策略 -->

## 备选方案
<!-- 曾考虑过的其它方案及其否决理由（尤其是更复杂者） -->

## 批准状态
<!-- DO NOT EDIT - 审批通过后由流程更新 -->
**状态**: PENDING
**批准人**: -
**批准日期**: -
"@ | Set-Content -Path $DesignFile
}
else {
@"
# Design Document

**ID**: $DesignId
**Date**: $Date
**Status**: DRAFT

## Requirement
<!-- To be filled in after alignment: goal and scope -->

## Summary
<!-- Clear, simple description of what will be done and why -->

## Context
<!-- Current state and why this change is needed -->

## Design Principles
- **KISS principle**: keep it simple, avoid over-engineering
- **Simplicity first**: prefer straightforward, maintainable solutions
- **No premature optimization**: do not introduce unnecessary complexity

## Detailed Design
<!-- 
- Architecture decisions (keep as simple as possible)
- Component breakdown (minimize complexity)
- Data flow and state management (choose simplest approach)
- API changes (if any) - keep interfaces clean and minimal
- Database schema changes (if any) - avoid unnecessary complexity
-->

## Implementation Plan
<!-- Step-by-step approach prioritizing simplicity and rollback safety -->

## Testing Strategy
<!-- Focus on essential tests and critical paths -->

## Risk Analysis
<!-- Potential issues and mitigations -->

## Alternatives Considered
<!-- Other options and why they were rejected (especially more complex ones) -->

## Approval Status
<!-- DO NOT EDIT - Updated when design is approved -->
**Status**: PENDING
**Approved By**: -
**Approval Date**: -
"@ | Set-Content -Path $DesignFile
}

if ($Json) {
    @{ PROJECT_ROOT = $RepoRoot; DESIGN_DIR = $DesignDir; DESIGN_FILE = $DesignFile; DESIGN_ID = $DesignId } | ConvertTo-Json -Compress
} else {
    Write-Host "PROJECT_ROOT: $RepoRoot"
    Write-Host "DESIGN_DIR: $DesignDir"
    Write-Host "DESIGN_FILE: $DesignFile"
    Write-Host "DESIGN_ID: $DesignId"
}
