#!/bin/bash

# Copy dotfiles
./copy.sh

# Update Ubuntu and get standard repository programs
sudo apt update && sudo apt full-upgrade -y

wanted_packages=(
  # Basics
  awscli
  chrome-gnome-shell
  curl
  exfat-utils
  file
  git
  htop
  jq
  yq
  nmap
  openvpn
  tree
  vim
  wget

  # Image processing
  gimp
  jpegoptim
  optipng
)

missing_packages=()

for package in "${wanted_packages[@]}"; do
  if ! which "$package" &> /dev/null; then
    missing_packages+=("$package")
  fi
done

printf \
  "The following packages are going to be installed:\n%s\n" \
  "${missing_packages[*]}"

if ! sudo apt install -y "${missing_packages[@]}"; then
  printf "Couldn't install some packages. Exiting.\n"
  exit 1
fi

# Run all scripts in programs/
for f in programs/*.sh; do bash "$f" -H; done

# Get all upgrades
sudo apt upgrade -y
sudo apt autoremove -y
