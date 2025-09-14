#!/usr/bin/env bash
# Execute an approved design document
set -e

JSON_MODE=false
DESIGN_ID_OR_PATH=""
ARGS=()
for arg in "$@"; do
    case "$arg" in
        --json) JSON_MODE=true ;;
        --help|-h) echo "Usage: $0 [--json] [design_id_or_path]"; exit 0 ;;
        *) ARGS+=("$arg") ;;
    esac
done

DESIGN_ID_OR_PATH="${ARGS[0]}"

REPO_ROOT=$(git rev-parse --show-toplevel)
DESIGNS_DIR="$REPO_ROOT/designs"

if [ ! -d "$DESIGNS_DIR" ]; then
    echo "ERROR: No designs directory found at $DESIGNS_DIR" >&2
    exit 1
fi

TARGET_DESIGN_DIR=""

if [ -n "$DESIGN_ID_OR_PATH" ]; then
    # If an argument is provided, try to find the design directory
    if [ -d "$DESIGN_ID_OR_PATH" ]; then
        TARGET_DESIGN_DIR="$DESIGN_ID_OR_PATH"
    elif [ -d "$DESIGNS_DIR/$DESIGN_ID_OR_PATH" ]; then
        TARGET_DESIGN_DIR="$DESIGNS_DIR/$DESIGN_ID_OR_PATH"
    else
        # Find directory that starts with the given ID
        CANDIDATE_DIRS=($(find "$DESIGNS_DIR" -maxdepth 1 -type d -name "${DESIGN_ID_OR_PATH}*"))
        if [ "${#CANDIDATE_DIRS[@]}" -eq 1 ]; then
            TARGET_DESIGN_DIR="${CANDIDATE_DIRS[0]}"
        elif [ "${#CANDIDATE_DIRS[@]}" -gt 1 ]; then
            echo "ERROR: Multiple design directories match '$DESIGN_ID_OR_PATH'. Please be more specific." >&2
            printf '%s\n' "${CANDIDATE_DIRS[@]}" >&2
            exit 1
        else
            echo "ERROR: Design with ID or path '$DESIGN_ID_OR_PATH' not found." >&2
            exit 1
        fi
    fi
else
    # If no argument, list available designs and exit.
    # The command definition (.md file) should instruct the AI to prompt the user.
    AVAILABLE_DESIGNS=$(find "$DESIGNS_DIR" -maxdepth 1 -type d -name '*_*' -exec basename {} \; | sort -r)
    if [ -z "$AVAILABLE_DESIGNS" ]; then
        echo "INFO: No design documents found in $DESIGNS_DIR"
        exit 0
    fi

    echo "INFO: Please specify which design to execute."
    echo "Available designs:"
    echo "$AVAILABLE_DESIGNS"
    # Exit cleanly, as the next step is for the AI to interact with the user.
    exit 0
fi

DESIGN_FILE="$TARGET_DESIGN_DIR/design.md"
if [ ! -f "$DESIGN_FILE" ]; then
    echo "ERROR: Design file not found at $DESIGN_FILE" >&2
    exit 1
fi

# Extract design ID from directory name
DESIGN_ID=$(basename "$TARGET_DESIGN_DIR")

# Check if design is approved
if ! grep -q "**Status**: APPROVED" "$DESIGN_FILE" 2>/dev/null; then
    echo "WARNING: Design document is not marked as APPROVED" >&2
    echo "Please ensure the design has been reviewed and approved before executing." >&2
fi

# Create execution log
EXECUTION_LOG="$TARGET_DESIGN_DIR/execution.log"
echo "Execution started at $(date)" > "$EXECUTION_LOG"
echo "Design ID: $DESIGN_ID" >> "$EXECUTION_LOG"

if $JSON_MODE; then
    printf '{"DESIGN_FILE":"%s","DESIGN_ID":"%s","PROJECT_ROOT":"%s"}\n' \
        "$DESIGN_FILE" "$DESIGN_ID" "$REPO_ROOT"
else
    echo "DESIGN_FILE: $DESIGN_FILE"
    echo "DESIGN_ID: $DESIGN_ID"
    echo "PROJECT_ROOT: $REPO_ROOT"
fi
