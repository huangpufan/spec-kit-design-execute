#!/usr/bin/env bash
#
# Spec-Kit Design & Execute - Uninstallation Script
#
# This script removes the sk-init command and the cloned repository.
#

set -e

# --- Configuration ---
INSTALL_DIR="$HOME/.spec-kit-design-execute"
CMD_NAME="sk-init"
SYMLINK_PATH="/usr/local/bin/$CMD_NAME"

# --- Helper Functions ---
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- Main Uninstallation Logic ---
echo "Uninstalling Spec-Kit Design & Execute..."

# 1. Remove symlink
if [ -L "$SYMLINK_PATH" ]; then
    echo "Removing symlink at $SYMLINK_PATH..."
    if [ -w "$(dirname "$SYMLINK_PATH")" ]; then
        rm -f "$SYMLINK_PATH"
    else
        if command_exists sudo; then
            echo "Sudo privileges are required to remove the symlink."
            sudo rm -f "$SYMLINK_PATH"
        else
            echo "Error: Cannot remove symlink. No write access to $(dirname "$SYMLINK_PATH") and sudo is not available." >&2
            echo "Please remove the symlink manually:" >&2
            echo "  rm -f \"$SYMLINK_PATH\"" >&2
            # We can still try to remove the directory
        fi
    fi
elif [ -f "$SYMLINK_PATH" ]; then
    echo "Warning: Found a file instead of a symlink at $SYMLINK_PATH. It will not be removed." >&2
fi

# 2. Remove the repository directory
if [ -d "$INSTALL_DIR" ]; then
    echo "Removing installation directory at $INSTALL_DIR..."
    rm -rf "$INSTALL_DIR"
fi

echo ""
echo "✅ Spec-Kit Design & Execute has been uninstalled."
echo ""
