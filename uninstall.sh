#!/usr/bin/env bash
#
# Spec-Lite - Uninstallation Script
#
# This script removes the sk-init command and the cloned repository.
#

set -e

# --- Fetch Common Functions ---
# Attempt to fetch the common script for styled output
COMMON_SCRIPT_URL="https://raw.githubusercontent.com/huangpufan/spec-lite/master/common-install.sh"
if command -v curl >/dev/null 2>&1; then
    if curl -sSL "$COMMON_SCRIPT_URL" -o "/tmp/spec-lite-common.sh"; then
        source "/tmp/spec-lite-common.sh"
    else
        # Define fallback functions if curl fails
        log_info() { echo "INFO: $1"; }
        log_success() { echo "SUCCESS: $1"; }
        log_error() { echo "ERROR: $1" >&2; }
        print_header() { echo -e "\n--- $1 ---"; }
        print_minor_step() { echo "  -> $1"; }
    fi
elif command -v wget >/dev/null 2>&1; then
    if wget -q "$COMMON_SCRIPT_URL" -O "/tmp/spec-lite-common.sh"; then
        source "/tmp/spec-lite-common.sh"
    else
        # Define fallback functions if wget fails
        log_info() { echo "INFO: $1"; }
        log_success() { echo "SUCCESS: $1"; }
        log_error() { echo "ERROR: $1" >&2; }
        print_header() { echo -e "\n--- $1 ---"; }
        print_minor_step() { echo "  -> $1"; }
    fi
else
    # Define fallback functions if no download tool is available
    log_info() { echo "INFO: $1"; }
    log_success() { echo "SUCCESS: $1"; }
    log_error() { echo "ERROR: $1" >&2; }
    print_header() { echo -e "\n--- $1 ---"; }
    print_minor_step() { echo "  -> $1"; }
fi


# --- Configuration ---
INSTALL_DIR="$HOME/.spec-lite"
CMD_NAMES=("sk-init" "sk-update")
SYMLINK_PATHS=("/usr/local/bin/sk-init" "/usr/local/bin/sk-update")

# --- Helper Functions ---
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- Main Uninstallation Logic ---
print_header "${EMOJI_TRASH} Uninstalling Spec-Lite"

# 1. Remove symlinks
print_minor_step "Removing command symlinks"
for i in "${!SYMLINK_PATHS[@]}"; do
    SYMLINK_PATH="${SYMLINK_PATHS[$i]}"
    CMD_NAME="${CMD_NAMES[$i]}"
    
    if [ -L "$SYMLINK_PATH" ]; then
        log_info "Removing symlink for '$CMD_NAME' at $SYMLINK_PATH..."
        if [ -w "$(dirname "$SYMLINK_PATH")" ]; then
            rm -f "$SYMLINK_PATH"
        else
            if command_exists sudo; then
                log_warning "Sudo privileges are required to remove the symlink."
                sudo rm -f "$SYMLINK_PATH"
            else
                log_error "Cannot remove symlink for '$CMD_NAME'. No write access to $(dirname "$SYMLINK_PATH") and sudo is not available."
                log_info "Please remove the symlink manually: sudo rm -f \"$SYMLINK_PATH\""
                # We can still try to remove the directory
            fi
        fi
    elif [ -f "$SYMLINK_PATH" ]; then
        log_warning "Found a file instead of a symlink at $SYMLINK_PATH. It will not be removed."
    fi
done

# 2. Remove the repository directory
if [ -d "$INSTALL_DIR" ]; then
    print_minor_step "Removing installation directory at $INSTALL_DIR"
    rm -rf "$INSTALL_DIR"
fi

echo ""
log_success "Spec-Lite has been uninstalled."
echo ""
