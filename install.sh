#!/usr/bin/env bash
#
# Spec-Lite - Installation Script
#
# This script installs the sk-init command for easy project setup.
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/huangpufan/spec-lite/master/install.sh | bash
#
# To install from a specific branch (e.g., dev):
#   curl -sSL https://raw.githubusercontent.com/huangpufan/spec-lite/master/install.sh | bash -s dev
#
# Or, to install a specific version:
#   curl -sSL https://raw.githubusercontent.com/huangpufan/spec-lite/v1.0.0/install.sh | bash
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
        print_step() { echo -e "\n--- $1 ---"; }
        print_minor_step() { echo "  -> $1"; }
        print_command() { echo "  $1"; }
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
        print_step() { echo -e "\n--- $1 ---"; }
        print_minor_step() { echo "  -> $1"; }
        print_command() { echo "  $1"; }
    fi
else
    # Define fallback functions if no download tool is available
    log_info() { echo "INFO: $1"; }
    log_success() { echo "SUCCESS: $1"; }
    log_error() { echo "ERROR: $1" >&2; }
    print_header() { echo -e "\n--- $1 ---"; }
    print_step() { echo -e "\n--- $1 ---"; }
    print_minor_step() { echo "  -> $1"; }
    print_command() { echo "  $1"; }
fi


BRANCH="${1:-master}" # Default to 'master' if no branch is provided

GITHUB_REPO="huangpufan/spec-lite"
INSTALL_DIR="$HOME/.spec-lite"
CMD_NAMES=("sk-init" "sk-update")
SYMLINK_PATHS=("/usr/local/bin/sk-init" "/usr/local/bin/sk-update")

# --- Helper Functions ---
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# --- Main Installation Logic ---
print_header "${EMOJI_ROCKET} Installing Spec-Lite"

# 1. Check for git
print_step "Checking prerequisites"
print_minor_step "Checking for git"
if ! command_exists git; then
    log_error "git is not installed. Please install it first."
    exit 1
fi
log_success "Git is installed"


# 2. Clone or update the repository
print_step "Downloading Spec-Lite"
if [ -d "$INSTALL_DIR" ]; then
    print_minor_step "Updating existing installation in $INSTALL_DIR to branch '$BRANCH'"
    cd "$INSTALL_DIR"
    git fetch origin >/dev/null 2>&1
    git checkout "$BRANCH" >/dev/null 2>&1
    git pull origin "$BRANCH" >/dev/null 2>&1
    cd - >/dev/null
else
    print_minor_step "Cloning repository (branch: $BRANCH) into $INSTALL_DIR"
    git clone --branch "$BRANCH" "https://github.com/$GITHUB_REPO.git" "$INSTALL_DIR" >/dev/null 2>&1
fi
log_success "Spec-Lite downloaded successfully"


# 3. Create symlinks to the commands
print_step "Setting up commands"
SCRIPT_PATHS=("$INSTALL_DIR/spec-kit-init" "$INSTALL_DIR/spec-kit-update")

# Check if all required scripts exist
print_minor_step "Verifying script files"
for i in "${!SCRIPT_PATHS[@]}"; do
    SCRIPT_PATH="${SCRIPT_PATHS[$i]}"
    CMD_NAME="${CMD_NAMES[$i]}"
    if [ ! -f "$SCRIPT_PATH" ]; then
        log_error "Installation failed. Could not find '$SCRIPT_PATH'."
        exit 1
    fi
done
log_success "All script files found"


print_minor_step "Creating symlinks in /usr/local/bin"
# Use sudo if the user doesn't have write permissions to /usr/local/bin
for i in "${!SCRIPT_PATHS[@]}"; do
    SCRIPT_PATH="${SCRIPT_PATHS[$i]}"
    SYMLINK_PATH="${SYMLINK_PATHS[$i]}"
    CMD_NAME="${CMD_NAMES[$i]}"
    
    log_info "Creating symlink for '$CMD_NAME'..."
    if [ -w "/usr/local/bin" ]; then
        ln -sf "$SCRIPT_PATH" "$SYMLINK_PATH"
    else
        if command_exists sudo; then
            log_warning "Sudo privileges are required to create the symlink."
            sudo ln -sf "$SCRIPT_PATH" "$SYMLINK_PATH"
        else
            log_error "Cannot create symlink for '$CMD_NAME'. No write access to /usr/local/bin and sudo is not available."
            log_info "Please create the symlink manually: ln -s \"$SCRIPT_PATH\" \"/path/on/your/PATH/$CMD_NAME\""
            exit 1
        fi
    fi
done
log_success "Symlinks created successfully"

# 4. Final instructions
print_header "${EMOJI_SPARKLE} Installation Complete"
log_success "Spec-Lite installed successfully!"
echo ""
log_info "Available commands:"
print_command "sk-init   - Set up Spec-Lite commands in your git repository"
print_command "sk-update - Update Spec-Lite and reinitialize current project if needed"
echo ""
log_info "Example usage:"
print_command "cd /path/to/your/project"
print_command "sk-init"
echo ""
log_info "To update Spec-Lite:"
print_command "sk-update"
echo ""
