#!/bin/bash
# kst - Simple terminal installation script

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if running as root, if not, use sudo
if [ "$EUID" -ne 0 ]; then
    SUDO="sudo"
else
    SUDO=""
fi

echo -e "${BLUE}Installing kst - Simple Terminal${NC}"

# Check for dependencies
echo -e "${YELLOW}Checking dependencies...${NC}"
DEPS=("make" "cc" "pkg-config" "fontconfig" "freetype2" "xorg-x11")
MISSING=()

for dep in "${DEPS[@]}"; do
    if ! command -v $dep >/dev/null 2>&1 && ! pkg-config --exists $dep 2>/dev/null; then
        MISSING+=($dep)
    fi
done

if [ ${#MISSING[@]} -ne 0 ]; then
    echo -e "${RED}Missing dependencies: ${MISSING[*]}${NC}"
    echo -e "Please install the required dependencies before continuing."
    exit 1
fi

# Compile
echo -e "${YELLOW}Compiling kst...${NC}"
make clean
if ! make; then
    echo -e "${RED}Compilation failed.${NC}"
    exit 1
fi

# Install
echo -e "${YELLOW}Installing kst...${NC}"
if ! $SUDO make install; then
    echo -e "${RED}Installation failed.${NC}"
    exit 1
fi

echo -e "${GREEN}kst has been successfully installed!${NC}"
echo -e "${BLUE}Run 'kst' to start the terminal.${NC}"
exit 0 