#!/usr/bin/env bash

#
# onboarding.sh
#
# Analyzes the project and generates a detailed context prompt for an AI 
# to write a Project Onboarding Document.
#

set -e

# --- Configuration ---
# Directories and files to exclude from the analysis.
EXCLUDE_PATTERNS=(
    "*/node_modules/*" "*/.git/*" "*/dist/*" "*/build/*" "*/coverage/*" 
    "*/.vscode/*" "*/.idea/*" "*/__pycache__/*" "*/*.egg-info/*" "*/target/*" 
    "*.png" "*.jpg" "*.jpeg" "*.gif" "*.svg" "*.ico" "*.woff" "*.woff2" 
    "*.ttf" "*.eot" "*.mp4" "*.webm" "*.zip" "*.gz" "*.lock" "*.min.js"
)
EXCLUDE_TREE_DIRS="'node_modules|.git|dist|build|coverage|.vscode|.idea|__pycache__|*.egg-info|target'"

# Max file size to read (100 KB) to avoid overly large context.
MAX_FILE_SIZE=100000

# --- Helper Functions ---

log_info() {
    echo "[ONBOARD] $1" >&2
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- Main Logic ---

# 1. Initialization and Parameter Parsing
ANALYZE_PATH="."
OUTPUT_FILE=".specify/onboarding.md"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -o|--output) OUTPUT_FILE="$2"; shift ;;
        *) ANALYZE_PATH="$1" ;;
    esac
    shift
done

PROJECT_ROOT=$(git rev-parse --show-toplevel)
ANALYZE_FULL_PATH="$PROJECT_ROOT/$ANALYZE_PATH"
OUTPUT_FILE_PATH="$PROJECT_ROOT/$OUTPUT_FILE"
TEMP_CONTEXT_FILE=$(mktemp)

trap 'rm -f "$TEMP_CONTEXT_FILE"' EXIT

log_info "Starting project analysis..."
log_info "Target Path: $ANALYZE_FULL_PATH"
log_info "Suggested Output: $OUTPUT_FILE_PATH"

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
        (cd "$ANALYZE_FULL_PATH" && find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g')
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

    find "$ANALYZE_FULL_PATH" -type f "${exclude_args[@]}" | while read -r filepath; do
        if file -b --mime-type "$filepath" | grep -q "text/"; then
            file_size=$(stat -c%s "$filepath")
            if (( file_size < MAX_FILE_SIZE )); then
                echo "$filepath"
            fi
        fi
    done | head -n 20 | while read -r filepath; do
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
cat <<EOF
You are a top-tier software architect. Based on the following project context, please write a detailed "Project Onboarding Document".
This document is for new developers (including AI assistants) to quickly understand the project and start contributing.

After you generate the document, I will save it to \`$OUTPUT_FILE_PATH\`.

**The document must include the following sections:**

1.  **Project Overview**: What is the project's purpose and core functionality?
2.  **Tech Stack**: What languages, frameworks, and major libraries are used?
3.  **Architecture Analysis**: What is the overall architecture? Describe the main modules and their relationships.
4.  **Code Structure**: Explain the purpose of key directories and files.
5.  **Core Logic Entrypoint**: How does the application start? Where does the key business logic begin?
6.  **Development Guide**: How to set up the local environment, start the project, and run tests?

---
**PROJECT CONTEXT PROVIDED BELOW**
---

$(cat "$TEMP_CONTEXT_FILE")
EOF
