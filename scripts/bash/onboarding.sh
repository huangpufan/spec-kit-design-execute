#!/usr/bin/env bash

#
# onboarding.sh
#
# Analyze the project and emit a structured prompt for generating a
# Project Onboarding Document. KISS-oriented, robust on common stacks.
#

set -euo pipefail
IFS=$'\n\t'

# --- Configuration ---
# Directories and files to exclude from the analysis.
EXCLUDE_PATTERNS=(
    "*/node_modules/*" "*/.git/*" "*/dist/*" "*/build/*" "*/coverage/*"
    "*/.vscode/*" "*/.idea/*" "*/__pycache__/*" "*/*.egg-info/*" "*/target/*"
    "*/.next/*" "*/.nuxt/*" "*/.svelte-kit/*" "*/.turbo/*" "*/.parcel-cache/*" "*/.cache/*"
    "*/venv/*" "*/.venv/*" "*/vendor/*"
    "*.png" "*.jpg" "*.jpeg" "*.gif" "*.svg" "*.ico" "*.woff" "*.woff2"
    "*.ttf" "*.eot" "*.mp4" "*.webm" "*.zip" "*.gz" "*.lock" "*.min.js" "*.map"
)
# Pattern for tree -I (OR-separated wildcard). Do not wrap in quotes again when passing to tree.
EXCLUDE_TREE_DIRS="node_modules|.git|dist|build|coverage|.vscode|.idea|__pycache__|*.egg-info|target|.next|.nuxt|.svelte-kit|.turbo|.parcel-cache|.cache|venv|.venv|vendor"

# Additional excludes for find pruning
EXCLUDE_DIRS=(node_modules .git dist build coverage .vscode .idea __pycache__ target .next .nuxt .svelte-kit .turbo .parcel-cache .cache venv .venv vendor)
EXCLUDE_NAMES=("*.png" "*.jpg" "*.jpeg" "*.gif" "*.svg" "*.ico" "*.woff" "*.woff2" "*.ttf" "*.eot" "*.mp4" "*.webm" "*.zip" "*.gz" "*.min.js" "*.map" "*.lock")

# Max file size to read (bytes) to avoid overly large context. Default: 100 KB
MAX_FILE_SIZE=100000

# Max number of code files to include in snippets section
FILE_LIMIT=20

# --- Helper Functions ---

log_info() {
    echo "[ONBOARD] $1" >&2
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Portable file size
get_file_size() {
    local path="$1"
    if stat -c%s "$path" >/dev/null 2>&1; then
        stat -c%s "$path"
    else
        stat -f%z "$path"
    fi
}

is_text_like() {
    local path="$1"
    if command_exists file; then
        local mime
        mime=$(file -b --mime-type "$path" 2>/dev/null || echo "")
        case "$mime" in
            text/*|application/json|application/x-yaml|application/yaml|application/xml|application/javascript)
                return 0 ;;
            *) return 1 ;;
        esac
    else
        # Fallback by extension
        case "$path" in
            *.md|*.txt|*.json|*.yml|*.yaml|*.xml|*.js|*.jsx|*.ts|*.tsx|*.mjs|*.cjs|*.sh|*.bash|*.zsh|*.ps1|*.py|*.rb|*.go|*.java|*.kt|*.scala|*.php|*.rs|*.c|*.cc|*.cpp|*.h|*.hpp|*.css|*.scss|*.less|*.toml|*.ini|*.cfg)
                return 0 ;;
            *) return 1 ;;
        esac
    fi
}

# --- Main Logic ---

# 1. Initialization (zero-argument usage)
ANALYZE_PATH="."
OUTPUT_FILE=".specify/onboarding.md"
LANGUAGE="en"

PROJECT_ROOT=$(git rev-parse --show-toplevel)
# Infer language from config if available
LANG_CONF="$PROJECT_ROOT/.specify/config/language.conf"
if [[ -f "$LANG_CONF" ]]; then
    LANG_VAL=$(grep -E '^LANGUAGE=' "$LANG_CONF" | sed 's/^LANGUAGE=//' | tr -d '\r\n' || true)
    if [[ -n "${LANG_VAL:-}" ]]; then
        LANGUAGE="$LANG_VAL"
    fi
fi
ANALYZE_FULL_PATH="$PROJECT_ROOT/$ANALYZE_PATH"
OUTPUT_FILE_PATH="$PROJECT_ROOT/$OUTPUT_FILE"
TEMP_CONTEXT_FILE=$(mktemp)

trap 'rm -f "$TEMP_CONTEXT_FILE"' EXIT

log_info "Starting project analysis..."
log_info "Target Path: $ANALYZE_FULL_PATH"
log_info "Suggested Output: $OUTPUT_FILE_PATH"
log_info "Language: $LANGUAGE"

# 2. Information Gathering
{
    echo "--- Project Context ---"
    echo ""

    # Section: File Structure
    log_info "Gathering file structure..."
    echo "## File Structure"
    if command_exists tree; then
        (cd "$ANALYZE_FULL_PATH" && tree -a -I "$EXCLUDE_TREE_DIRS")
    else
        log_info "'tree' command not found, using 'find' as a fallback."
        # Build -prune expression for excluded directories
        prune_expr=()
        for d in "${EXCLUDE_DIRS[@]}"; do
            prune_expr+=( -name "$d" -o )
        done
        # Remove trailing -o
        unset 'prune_expr[${#prune_expr[@]}-1]'
        (
          cd "$ANALYZE_FULL_PATH" && \
          find . \( \( ${prune_expr[@]} \) -prune \) -o -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
        )
    fi
    echo ""

    # Section: Tech Stack Identification
    log_info "Identifying tech stack from configuration files..."
    echo "## Tech Stack & Configuration Files"
    TECH_FILES=( 
        "package.json" "pom.xml" "build.gradle" "requirements.txt" "Pipfile" 
        "go.mod" "Cargo.toml" "composer.json" "Gemfile" "vite.config.js" 
        "vite.config.ts" "webpack.config.js" "next.config.js" "tsconfig.json" 
        "Dockerfile" "docker-compose.yml" ".gitlab-ci.yml" 
    )
    # Also look for workflow files
    find "$ANALYZE_FULL_PATH" -path "*/.github/workflows/*.yml" -type f -print0 | 
    while IFS= read -r -d $'\0' filepath; do
        log_info "Found workflow file: $filepath"
        echo "### Contents of $(basename "$filepath")"
        echo '```'
        cat "$filepath"
        echo '```'
        echo ""
    done
    for file in "${TECH_FILES[@]}"; do
        find "$ANALYZE_FULL_PATH" -name "$file" -type f -print0 | while IFS= read -r -d $'\0' filepath; do
            log_info "Found tech file: $filepath"
            echo "### Contents of $(basename "$filepath")"
            echo '```'
            cat "$filepath"
            echo '```'
            echo ""
        done
    done

    # Section: Key Source Code
    log_info "Extracting key source code..."
    echo "## Key Source Code Snippets"
    
    exclude_args=()
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        exclude_args+=(-not -path "$pattern")
    done

    # Priority: known entrypoints first, then other text files
    PRIORITY_NAMES=(
        "package.json" "pnpm-workspace.yaml" "yarn.lock" "pnpm-lock.yaml" "package-lock.json"
        "requirements.txt" "pyproject.toml" "Pipfile" "Pipfile.lock"
        "go.mod" "Cargo.toml" "composer.json" "Gemfile"
        "vite.config.ts" "vite.config.js" "webpack.config.js" "next.config.js" "nuxt.config.ts" "nuxt.config.js"
        "tsconfig.json" "babel.config.js" "jest.config.js" "eslint.config.js" ".eslintrc" ".eslintrc.js" ".eslintrc.cjs"
        "Makefile" "Dockerfile" "docker-compose.yml" ".tool-versions"
        "README.md" "README.en.md" "README.zh.md"
        "src/main.ts" "src/main.tsx" "src/index.ts" "src/index.tsx" "src/main.js" "src/index.js" "src/app.ts" "src/app.tsx" "src/app.js"
        "cmd/main.go" "main.go" "cmd/server/main.go"
        "manage.py" "app.py" "server.js" "server.ts"
    )

    # Collect prioritized files
    prioritized_files=()
    for name in "${PRIORITY_NAMES[@]}"; do
        while IFS= read -r -d $'\0' f; do
            prioritized_files+=("$f")
        done < <(find "$ANALYZE_FULL_PATH" -type f -name "$name" -print0 2>/dev/null || true)
    done

    # Collect other text files under limits and excludes
    other_files=()
    while IFS= read -r -d $'\0' f; do
        other_files+=("$f")
    done < <(find "$ANALYZE_FULL_PATH" -type f \
        $(printf ' -not -path %q' "${EXCLUDE_PATTERNS[@]}") -print0 2>/dev/null)

    # Merge lists with uniqueness, filter text-like and size
    unique_list=()
    declare -A seen
    for f in "${prioritized_files[@]}" "${other_files[@]}"; do
        [[ -z "${f:-}" ]] && continue
        if [[ -z "${seen[$f]:-}" ]]; then
            seen[$f]=1
            if is_text_like "$f"; then
                size=$(get_file_size "$f" || echo 0)
                if [[ "$size" -lt "$MAX_FILE_SIZE" ]]; then
                    unique_list+=("$f")
                fi
            fi
        fi
        if [[ ${#unique_list[@]} -ge $FILE_LIMIT ]]; then
            break
        fi
    done

    for filepath in "${unique_list[@]}"; do
        log_info "Adding source file: $filepath"
        RELATIVE_PATH=${filepath#"$PROJECT_ROOT/"}
        echo "### Contents of $RELATIVE_PATH"
        echo '```'
        cat "$filepath"
        echo '```'
        echo ""
    done

} > "$TEMP_CONTEXT_FILE"

log_info "Context gathering complete. Generating final prompt..."

# 3. Final Prompt Generation
# This is printed to stdout and will be picked up by Cursor.
if [[ "$LANGUAGE" == "zh" ]]; then
cat <<EOF
你是一位顶尖的软件架构师。请基于以下项目上下文，撰写一份详细的《项目引导文档 (Project Onboarding Document)》。
该文档用于帮助新成员（包括 AI 助手）快速理解项目并开始贡献。

生成完成后，请将结果保存到 \`$OUTPUT_FILE_PATH\`。

文档至少包含以下章节：

1. 项目概览：项目目标与核心功能
2. 技术栈：语言、框架与主要依赖
3. 架构分析：整体架构、主要模块与关系
4. 代码结构：关键目录与文件的作用
5. 核心入口：应用如何启动，关键业务从哪里开始
6. 开发指南：如何安装依赖、启动、运行测试
7. 约定与模式：命名、代码风格、常用工具方法
8. 重要脚本/任务：build、lint、test、start 等
9. 风险与注意事项：已知限制、易踩坑

---
以下为项目上下文：
---

$(cat "$TEMP_CONTEXT_FILE")
EOF
else
cat <<EOF
You are a top-tier software architect. Based on the following project context, please write a detailed "Project Onboarding Document".
This document is for new developers (including AI assistants) to quickly understand the project and start contributing.

After you generate the document, please save it to \`$OUTPUT_FILE_PATH\`.

Include at least the following sections:

1. Project Overview
2. Tech Stack
3. Architecture Analysis
4. Code Structure
5. Core Logic Entrypoint
6. Development Guide (setup, run, test)
7. Conventions & Patterns
8. Important Scripts/Tasks
9. Risks & Caveats

---
PROJECT CONTEXT BELOW
---

$(cat "$TEMP_CONTEXT_FILE")
EOF
fi
