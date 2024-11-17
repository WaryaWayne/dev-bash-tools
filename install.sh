#!/usr/bin/env bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Installation directories
INSTALL_DIR="$HOME/.local/bin"
TOOLS_DIR="$HOME/.local/share/devtools"
SCRIPTS_DIR="scripts"

# Available scripts with descriptions
declare -A SCRIPTS
SCRIPTS=(
    ["1|defStart"]="Automates Python project setup with Pipenv and VS Code configuration"
    ["2|setVsco"]="Sets Python interpreter in VS Code for Pipenv environments"
    ["3|conImg"]="Converts image files between formats using ffmpeg"
    ["4|gitSetup"]="Initializes Git repository with custom configurations"
    ["5|djangoReact"]="Sets up Django backend and/or React frontend projects"
    ["6|stripeSetup"]="Configures Stripe integration for web applications"
)

# Print colored message
print_colored() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Display available scripts
show_scripts() {
    print_colored "$BLUE" "\nAvailable scripts:"
    for key in "${!SCRIPTS[@]}"; do
        local num=$(echo "$key" | cut -d'|' -f1)
        local name=$(echo "$key" | cut -d'|' -f2)
        echo -e "${GREEN}$num${NC}) $name"
        echo "   ${SCRIPTS[$key]}"
    done
}

# Validate script selection
validate_selection() {
    local selection=$1
    local valid=0
    
    # Check if it's a number
    if [[ $selection =~ ^[0-9]+$ ]]; then
        for key in "${!SCRIPTS[@]}"; do
            local num=$(echo "$key" | cut -d'|' -f1)
            if [ "$selection" = "$num" ]; then
                valid=1
                break
            fi
        done
    else
        # Check if it's a script name
        for key in "${!SCRIPTS[@]}"; do
            local name=$(echo "$key" | cut -d'|' -f2)
            if [ "$selection" = "$name" ]; then
                valid=1
                break
            fi
        done
    fi
    
    return $valid
}

# Get script name from selection
get_script_name() {
    local selection=$1
    
    # If it's a number, get the corresponding script name
    if [[ $selection =~ ^[0-9]+$ ]]; then
        for key in "${!SCRIPTS[@]}"; do
            local num=$(echo "$key" | cut -d'|' -f1)
            local name=$(echo "$key" | cut -d'|' -f2)
            if [ "$selection" = "$num" ]; then
                echo "$name"
                return
            fi
        done
    else
        # If it's a name, return it directly
        echo "$selection"
    fi
}

# Check dependencies
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
    print_colored "$BLUE" "Welcome to devtools installer!"
    
    # Show available scripts
    show_scripts
    
    # Prompt for selection
    print_colored "$BLUE" "\nEnter the numbers or names of scripts to install (space-separated):"
    read -r selections
    
    # Create necessary directories
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$TOOLS_DIR"
    
    # Process each selection
    for selection in $selections; do
        if ! validate_selection "$selection"; then
            print_colored "$RED" "Invalid selection: $selection"
            continue
        fi
        
        script_name=$(get_script_name "$selection")
        print_colored "$BLUE" "Installing $script_name..."
        
        # Copy script to tools directory
        cp "$SCRIPTS_DIR/$script_name" "$TOOLS_DIR/" || {
            print_colored "$RED" "Error: Failed to copy $script_name"
            continue
        }
        
        # Make script executable
        chmod +x "$TOOLS_DIR/$script_name"
        
        # Create symbolic link
        ln -sf "$TOOLS_DIR/$script_name" "$INSTALL_DIR/$script_name"
        
        print_colored "$GREEN" "✓ Installed $script_name"
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

# Check dependencies first
check_dependencies

# Run main installation
main "$@"