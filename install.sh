#!/usr/bin/env bash
#
# Spec-Lite - Installation Script
#
# This script installs the sk-init command for easy project setup.
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/huangpufan/spec-lite/main/install.sh | bash
#
# To install from a specific branch (e.g., dev):
#   curl -sSL https://raw.githubusercontent.com/huangpufan/spec-lite/main/install.sh | bash -s dev
#
# Or, to install a specific version:
#   curl -sSL https://raw.githubusercontent.com/huangpufan/spec-lite/v1.0.0/install.sh | bash
#

set -e

BRANCH="${1:-main}" # Default to 'main' if no branch is provided

GITHUB_REPO="huangpufan/spec-lite"
INSTALL_DIR="$HOME/.spec-lite"
CMD_NAMES=("sk-init" "sk-update")
SYMLINK_PATHS=("/usr/local/bin/sk-init" "/usr/local/bin/sk-update")

# --- Helper Functions ---
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- Main Installation Logic ---
echo "Installing Spec-Lite..."

# 1. Check for git
if ! command_exists git; then
    echo "Error: git is not installed. Please install it first." >&2
    exit 1
fi

# 2. Clone or update the repository
if [ -d "$INSTALL_DIR" ]; then
    echo "Updating existing installation in $INSTALL_DIR to branch '$BRANCH'..."
    cd "$INSTALL_DIR"
    git fetch origin
    git checkout "$BRANCH"
    git pull origin "$BRANCH"
    cd - >/dev/null
else
    echo "Cloning repository (branch: $BRANCH) into $INSTALL_DIR..."
    git clone --branch "$BRANCH" "https://github.com/$GITHUB_REPO.git" "$INSTALL_DIR"
fi

# 3. Create symlinks to the commands
SCRIPT_PATHS=("$INSTALL_DIR/spec-kit-init" "$INSTALL_DIR/spec-kit-update")

# Check if all required scripts exist
for i in "${!SCRIPT_PATHS[@]}"; do
    SCRIPT_PATH="${SCRIPT_PATHS[$i]}"
    CMD_NAME="${CMD_NAMES[$i]}"
    if [ ! -f "$SCRIPT_PATH" ]; then
        echo "Error: Installation failed. Could not find '$SCRIPT_PATH'." >&2
        exit 1
    fi
done

echo "Creating symlinks..."
# Use sudo if the user doesn't have write permissions to /usr/local/bin
for i in "${!SCRIPT_PATHS[@]}"; do
    SCRIPT_PATH="${SCRIPT_PATHS[$i]}"
    SYMLINK_PATH="${SYMLINK_PATHS[$i]}"
    CMD_NAME="${CMD_NAMES[$i]}"
    
    echo "Creating symlink for $CMD_NAME at $SYMLINK_PATH..."
    if [ -w "/usr/local/bin" ]; then
        ln -sf "$SCRIPT_PATH" "$SYMLINK_PATH"
    else
        if command_exists sudo; then
            echo "Sudo privileges are required to create the symlink in /usr/local/bin."
            sudo ln -sf "$SCRIPT_PATH" "$SYMLINK_PATH"
        else
            echo "Error: Cannot create symlink for $CMD_NAME. No write access to /usr/local/bin and sudo is not available." >&2
            echo "Please create the symlink manually:" >&2
            echo "  ln -s \"$SCRIPT_PATH\" \"/path/on/your/PATH/$CMD_NAME\"" >&2
            exit 1
        fi
    fi
done

# 4. Final instructions
echo ""
echo "✅ Spec-Lite installed successfully!"
echo ""
echo "Available commands:"
echo "  sk-init   - Set up Spec-Lite commands in your git repository"
echo "  sk-update - Update Spec-Lite and reinitialize current project if needed"
echo ""
echo "Example usage:"
echo "  cd /path/to/your/project"
echo "  sk-init"
echo ""
echo "To update Spec-Lite:"
echo "  sk-update"
echo ""
