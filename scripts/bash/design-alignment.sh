#!/usr/bin/env bash
# Create a design document for comprehensive requirement alignment (language-aware, KISS)
set -e

JSON_MODE=false
ARGS=()
for arg in "$@"; do
    case "$arg" in
        --json) JSON_MODE=true ;;
        --help|-h) echo "Usage: $0 [--json] <slug_or_requirement>"; exit 0 ;;
        *) ARGS+=("$arg") ;;
    esac
done

INPUT_TEXT="${ARGS[*]}"
if [ -z "$INPUT_TEXT" ]; then
    echo "Usage: $0 [--json] <slug_or_requirement>" >&2
    exit 1
fi

REPO_ROOT=$(git rev-parse --show-toplevel)
DESIGNS_DIR="$REPO_ROOT/designs"
mkdir -p "$DESIGNS_DIR"

# Detect language configuration (default: en)
LANGUAGE="en"
LANG_CONF="$REPO_ROOT/.specify/config/language.conf"
if [ -f "$LANG_CONF" ]; then
    LANGUAGE_VALUE=$(grep -E '^LANGUAGE=' "$LANG_CONF" | sed 's/^LANGUAGE=//' | tr -d '\r\n') || true
    if [ -n "$LANGUAGE_VALUE" ]; then
        LANGUAGE="$LANGUAGE_VALUE"
    fi
fi

# Generate design ID based on timestamp
DESIGN_ID=$(date +%Y%m%d_%H%M%S)

# Generate a kebab-case ASCII slug (fallback-safe)
generate_slug() {
    python3 - "$1" <<'PY'
import sys, re, unicodedata
text = sys.argv[1]
text = unicodedata.normalize('NFKD', text)
text = text.encode('ascii', 'ignore').decode('ascii')
text = re.sub(r'[^a-zA-Z0-9]+', '-', text).strip('-').lower()
parts = [p for p in text.split('-') if p]
print('-'.join(parts[:5]))
PY
}

SLUG=$(generate_slug "$INPUT_TEXT")
if [ -z "$SLUG" ]; then
    SLUG="design"
fi

# Create design directory
DESIGN_DIR="$DESIGNS_DIR/${DESIGN_ID}_${SLUG}"
mkdir -p "$DESIGN_DIR"

# Create design file
DESIGN_FILE="$DESIGN_DIR/design.md"
DATE=$(date +%Y-%m-%d)

if [ "$LANGUAGE" = "zh" ]; then
    cat > "$DESIGN_FILE" <<EOF
# 设计文档

**ID**: $DESIGN_ID
**Date**: $DATE
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
EOF
else
    cat > "$DESIGN_FILE" <<EOF
# Design Document

**ID**: $DESIGN_ID
**Date**: $DATE
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
EOF
fi

if $JSON_MODE; then
    printf '{"PROJECT_ROOT":"%s","DESIGN_DIR":"%s","DESIGN_FILE":"%s","DESIGN_ID":"%s"}\n' "$REPO_ROOT" "$DESIGN_DIR" "$DESIGN_FILE" "$DESIGN_ID"
else
    echo "PROJECT_ROOT: $REPO_ROOT"
    echo "DESIGN_DIR: $DESIGN_DIR"
    echo "DESIGN_FILE: $DESIGN_FILE"
    echo "DESIGN_ID: $DESIGN_ID"
fi
