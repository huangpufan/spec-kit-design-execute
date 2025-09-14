#!/usr/bin/env bash
#
# Spec-Kit Design & Execute - Installation Script
#
# This script installs the spec-kit-init command for easy project setup.
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install.sh | bash
#
# Or, to install a specific version:
#   curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/v1.0.0/install.sh | bash
#

set -e

# --- Configuration ---
# TODO: Replace with your actual GitHub username and repository name
GITHUB_REPO="huangpufan/spec-kit-design-execute"
INSTALL_DIR="$HOME/.spec-kit-design-execute"
CMD_NAME="sk-init"
SYMLINK_PATH="/usr/local/bin/$CMD_NAME"

# --- Helper Functions ---
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- Main Installation Logic ---
echo "Installing Spec-Kit Design & Execute..."

# 1. Check for git
if ! command_exists git; then
    echo "Error: git is not installed. Please install it first." >&2
    exit 1
fi

# 2. Clone or update the repository
if [ -d "$INSTALL_DIR" ]; then
    echo "Updating existing installation in $INSTALL_DIR..."
    cd "$INSTALL_DIR"
    git pull
    cd - >/dev/null
else
    echo "Cloning repository into $INSTALL_DIR..."
    git clone "https://github.com/$GITHUB_REPO.git" "$INSTALL_DIR"
fi

# 3. Create symlink to the command
# The main script to be linked is inside the cloned repo
INIT_SCRIPT_PATH="$INSTALL_DIR/spec-kit-init"

if [ ! -f "$INIT_SCRIPT_PATH" ]; then
    echo "Error: Installation failed. Could not find '$INIT_SCRIPT_PATH'." >&2
    exit 1
fi

echo "Creating symlink at $SYMLINK_PATH..."
# Use sudo if the user doesn't have write permissions to /usr/local/bin
if [ -w "/usr/local/bin" ]; then
    ln -sf "$INIT_SCRIPT_PATH" "$SYMLINK_PATH"
else
    if command_exists sudo; then
        echo "Sudo privileges are required to create the symlink in /usr/local/bin."
        sudo ln -sf "$INIT_SCRIPT_PATH" "$SYMLINK_PATH"
    else
        echo "Error: Cannot create symlink. No write access to /usr/local/bin and sudo is not available." >&2
        echo "Please create the symlink manually:" >&2
        echo "  ln -s \"$INIT_SCRIPT_PATH\" \"/path/on/your/PATH/$CMD_NAME\"" >&2
        exit 1
    fi
fi

# 4. Final instructions
echo ""
echo "✅ Spec-Kit Design & Execute installed successfully!"
echo ""
echo "You can now run 'sk-init' in any git repository to set up the commands."
echo "Example:"
echo "  cd /path/to/your/project"
echo "  sk-init"
echo ""
