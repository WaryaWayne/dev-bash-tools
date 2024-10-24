#!/usr/bin/env bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Installation directories
INSTALL_DIR="$HOME/.local/bin"
TOOLS_DIR="$HOME/.local/share/devtools"

# Print colored message
print_colored() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Main uninstallation
main() {
    print_colored "$BLUE" "Starting uninstallation of devtools..."
    
    # Remove symbolic links
    print_colored "$BLUE" "Removing command links..."
    
    # Iterate over all scripts in the tools directory
    for script in "$TOOLS_DIR"/*; do
        script_name=$(basename "$script")
        rm -f "$INSTALL_DIR/$script_name" # Remove each symbolic link
    done
    
    # Remove tools directory
    print_colored "$BLUE" "Removing installed scripts..."
    rm -rf "$TOOLS_DIR"
    
    # Remove PATH entries
    print_colored "$BLUE" "Cleaning up PATH..."
    if [ -f "$HOME/.bashrc" ]; then
        sed -i.bak '/export PATH="\$HOME\/\.local\/bin:\$PATH"/d' "$HOME/.bashrc"
    fi
    if [ -f "$HOME/.zshrc" ]; then
        sed -i.bak '/export PATH="\$HOME\/\.local\/bin:\$PATH"/d' "$HOME/.zshrc"
    fi
    
    print_colored "$GREEN" "✨ Uninstallation complete!"
    print_colored "$BLUE" "Please restart your terminal for changes to take effect."
}

# Confirmation prompt
print_colored "$RED" "This will remove all devtools scripts and settings."
read -p "Are you sure you want to continue? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    main "$@"
else
    print_colored "$BLUE" "Uninstallation cancelled."
fi