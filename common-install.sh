#!/usr/bin/env bash

# ==============================================================================
# Common Script for Spec-Lite Installation & Updates
#
# Provides colored logging, headers, and utility functions to create a
# consistent and readable output for installation and update scripts.
# ==============================================================================

# --- Colors and Styles ---
# Using tput for wider compatibility
if command -v tput >/dev/null 2>&1 && [[ $(tput colors) -ge 8 ]]; then
    COLOR_RESET=$(tput sgr0)
    COLOR_RED=$(tput setaf 1)
    COLOR_GREEN=$(tput setaf 2)
    COLOR_YELLOW=$(tput setaf 3)
    COLOR_BLUE=$(tput setaf 4)
    COLOR_PURPLE=$(tput setaf 5)
    COLOR_CYAN=$(tput setaf 6)
    COLOR_WHITE=$(tput setaf 7)
    COLOR_BOLD=$(tput bold)
else
    # Fallback to ANSI escape codes if tput is not available
    COLOR_RESET='\033[0m'
    COLOR_RED='\033[0;31m'
    COLOR_GREEN='\033[0;32m'
    COLOR_YELLOW='\033[0;33m'
    COLOR_BLUE='\033[0;34m'
    COLOR_PURPLE='\033[0;35m'
    COLOR_CYAN='\033[0;36m'
    COLOR_WHITE='\033[0;37m'
    COLOR_BOLD='\033[1m'
fi


# --- Emojis for Visual Feedback ---
EMOJI_ROCKET="🚀"
EMOJI_CHECK="✅"
EMOJI_CROSS="❌"
EMOJI_INFO="ℹ️"
EMOJI_WARN="⚠️"
EMOJI_TRASH="🗑️"
EMOJI_LINK="🔗"
EMOJI_DOWN="🔽"
EMOJI_UP="🔼"
EMOJI_WRENCH="🔧"
EMOJI_BOX="📦"
EMOJI_LOOP="🔄"
EMOJI_SPARKLE="✨"

# --- Logging Functions ---
# Prints an informational message
log_info() {
    echo -e "${COLOR_CYAN}${EMOJI_INFO} $1${COLOR_RESET}"
}

# Prints a success message
log_success() {
    echo -e "${COLOR_GREEN}${EMOJI_CHECK} $1${COLOR_RESET}"
}

# Prints a warning message
log_warning() {
    echo -e "${COLOR_YELLOW}${EMOJI_WARN} $1${COLOR_RESET}"
}

# Prints an error message to stderr
log_error() {
    echo -e "${COLOR_RED}${EMOJI_CROSS} ${COLOR_BOLD}Error:${COLOR_RESET}${COLOR_RED} $1${COLOR_RESET}" >&2
}

# --- UI Functions ---
# Prints a main header for a major stage
print_header() {
    echo -e "\n${COLOR_PURPLE}${COLOR_BOLD}"
    echo "=================================================="
    echo "  $1"
    echo "=================================================="
    echo -e "${COLOR_RESET}"
}

# Prints a separator for a step within a stage
print_step() {
    echo -e "\n${COLOR_BLUE}${COLOR_BOLD}${EMOJI_WRENCH} $1...${COLOR_RESET}"
}

# Prints a minor, indented step
print_minor_step() {
    echo -e "  ${COLOR_CYAN}->${COLOR_RESET} $1"
}

# Prints a command for user reference
print_command() {
    echo -e "  ${COLOR_YELLOW}$1${COLOR_RESET}"
}
