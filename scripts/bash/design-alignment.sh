#!/usr/bin/env bash
# Create a design document for comprehensive requirement alignment
set -e

JSON_MODE=false
ARGS=()
for arg in "$@"; do
    case "$arg" in
        --json) JSON_MODE=true ;;
        --help|-h) echo "Usage: $0 [--json] <requirement_description>"; exit 0 ;;
        *) ARGS+=("$arg") ;;
    esac
done

REQUIREMENT_DESCRIPTION="${ARGS[*]}"
if [ -z "$REQUIREMENT_DESCRIPTION" ]; then
    echo "Usage: $0 [--json] <requirement_description>" >&2
    exit 1
fi

REPO_ROOT=$(git rev-parse --show-toplevel)
DESIGNS_DIR="$REPO_ROOT/designs"
mkdir -p "$DESIGNS_DIR"

# Generate design ID based on timestamp
DESIGN_ID=$(date +%Y%m%d_%H%M%S)

# Function to generate a sanitized name from the requirement
generate_design_name() {
    local input="$1"
    # Use Python to create a URL-friendly slug, handles Unicode well
    python3 -c "
import sys
import re
from urllib.parse import quote

text = sys.argv[1]
# For Chinese, pinyin conversion would be ideal, but for now, we'll use URL encoding for non-ASCII
# A better slug function might involve a library like slugify or pypinyin
# Here is a simplified version:
text = re.sub(r'[^\w\s-]', '', text).strip().lower()
words = re.split(r'[\s-]+', text)[:5]
print('-'.join(words))
" "$input"
}

# Create a sanitized name from the requirement
DESIGN_NAME=$(generate_design_name "$REQUIREMENT_DESCRIPTION")

# Create design directory
DESIGN_DIR="$DESIGNS_DIR/${DESIGN_ID}_${DESIGN_NAME}"
mkdir -p "$DESIGN_DIR"

# Create design file
DESIGN_FILE="$DESIGN_DIR/design.md"

# Create initial design template
cat > "$DESIGN_FILE" << 'EOF'
# Design Document

**ID**: [DESIGN_ID]
**Date**: [DATE]
**Status**: DRAFT

## Requirement
[REQUIREMENT]

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
EOF

# Replace placeholders
sed -i.bak "s/\[DESIGN_ID\]/$DESIGN_ID/g" "$DESIGN_FILE"
sed -i.bak "s/\[DATE\]/$(date +%Y-%m-%d)/g" "$DESIGN_FILE"
sed -i.bak "s/\[REQUIREMENT\]/$REQUIREMENT_DESCRIPTION/g" "$DESIGN_FILE"
rm "$DESIGN_FILE.bak"

if $JSON_MODE; then
    printf '{"PROJECT_ROOT":"%s","DESIGN_DIR":"%s","DESIGN_FILE":"%s","DESIGN_ID":"%s"}\n' \
        "$REPO_ROOT" "$DESIGN_DIR" "$DESIGN_FILE" "$DESIGN_ID"
else
    echo "PROJECT_ROOT: $REPO_ROOT"
    echo "DESIGN_DIR: $DESIGN_DIR"
    echo "DESIGN_FILE: $DESIGN_FILE"
    echo "DESIGN_ID: $DESIGN_ID"
fi
