#!/bin/bash
# Simple installation script for kst terminal

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Root check
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Error: Please run as root or with sudo${NC}"
  exit 1
fi

# Detect OS
if [ -f /etc/arch-release ]; then
  echo -e "${GREEN}Installing dependencies for Arch Linux...${NC}"
  pacman -S --needed make libx11 libxft libxinerama fontconfig freetype2 harfbuzz
elif [ -f /etc/debian_version ]; then
  echo -e "${GREEN}Installing dependencies for Debian/Ubuntu...${NC}"
  apt install -y make libx11-dev libxft-dev libxinerama-dev libfontconfig1-dev libfreetype6-dev libharfbuzz-dev
elif [ -f /etc/fedora-release ]; then
  echo -e "${GREEN}Installing dependencies for Fedora...${NC}"
  dnf install -y make libX11-devel libXft-devel libXinerama-devel fontconfig-devel freetype-devel harfbuzz-devel
else
  echo -e "${RED}Unsupported OS. Please install dependencies manually.${NC}"
  exit 1
fi

# Build and install
echo -e "${GREEN}Building kst...${NC}"
make clean
make
echo -e "${GREEN}Installing kst...${NC}"
make install

echo -e "${GREEN}Installation complete! Run 'kst' to launch the terminal.${NC}"
exit 0 