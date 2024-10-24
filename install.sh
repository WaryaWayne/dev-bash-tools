#!/usr/bin/env bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Installation directories
INSTALL_DIR="$HOME/.local/bin"
TOOLS_DIR="$HOME/.local/share/devtools"
SCRIPTS_DIR="scripts" # Assuming scripts are in a directory named 'scripts' at the same level as this script

# Print colored message
print_colored() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Check for required commands
check_dependencies() {
    local missing_deps=()
    
    for cmd in pipenv code git ffmpeg; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_colored "$RED" "Error: Missing required dependencies:"
        printf '%s\n' "${missing_deps[@]}"
        print_colored "$BLUE" "Please install the missing dependencies and try again."
        exit 1
    fi
}

# Main installation
main() {
    print_colored "$BLUE" "Starting installation of devtools..."
    
    # Check dependencies
    check_dependencies
    
    # Create necessary directories
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$TOOLS_DIR"
    
    # Copy scripts to tools directory
    print_colored "$BLUE" "Copying scripts from $SCRIPTS_DIR..."
    cp -r "$SCRIPTS_DIR/"* "$TOOLS_DIR/" || {
        print_colored "$RED" "Error: Failed to copy scripts."
        exit 1
    }
    
    # Make scripts executable
    chmod +x "$TOOLS_DIR"/*
    
    # Create symbolic links in bin directory
    print_colored "$BLUE" "Creating command links..."
    for script in "$TOOLS_DIR"/*; do
        name=$(basename "$script")
        ln -sf "$script" "$INSTALL_DIR/${name%.*}"
    done
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        print_colored "$BLUE" "Adding tools to PATH..."
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    fi
    
    print_colored "$GREEN" "✨ Installation complete!"
    print_colored "$BLUE" "Please restart your terminal or run:"
    echo "source ~/.bashrc  # if using bash"
    echo "source ~/.zshrc   # if using zsh"
}

main "$@"
