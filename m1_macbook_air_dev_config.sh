#!/bin/bash
# =============================================================================
# M1 MacBook Air Developer Configuration Script
# =============================================================================
# This script sets up a complete development environment on an Apple Silicon
# (M1) MacBook Air. Run it once after a fresh macOS installation.
# Usage: chmod +x m1_macbook_air_dev_config.sh && ./m1_macbook_air_dev_config.sh
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Install Homebrew (Package Manager)
# -----------------------------------------------------------------------------
# Homebrew is the most popular package manager for macOS. It lets you install
# command-line tools and applications easily from the terminal.
# On Apple Silicon Macs, Homebrew is installed in /opt/homebrew (instead of
# /usr/local on Intel Macs) to support the arm64 architecture natively.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to the current shell's PATH so that brew commands are available
# immediately without restarting the terminal.
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# -----------------------------------------------------------------------------
# 2. Update and Upgrade Homebrew
# -----------------------------------------------------------------------------
# `brew update`  - Fetches the latest version of Homebrew and all formula
#                  definitions so you have access to the newest package versions.
# `brew upgrade` - Upgrades all already-installed packages to their latest
#                  versions to keep the environment secure and up to date.
brew update
brew upgrade

# -----------------------------------------------------------------------------
# 3. Install Git
# -----------------------------------------------------------------------------
# Git is the industry-standard distributed version control system. It is used
# to track source code changes, collaborate with other developers, and manage
# project history. macOS ships with an older Apple Git; installing via Homebrew
# gives you the latest upstream version.
brew install git

# Configure Git with your identity so commits are properly attributed.
# Replace the placeholder values with your actual name and email address.
git config --global user.name  "Your Name"
git config --global user.email "you@example.com"

# Set the default branch name to 'main' (the modern GitHub convention).
git config --global init.defaultBranch main

# Use the macOS Keychain to store Git credentials securely so you are not
# prompted for a password on every push/pull.
git config --global credential.helper osxkeychain

# -----------------------------------------------------------------------------
# 4. Install Rosetta 2
# -----------------------------------------------------------------------------
# Rosetta 2 is an Apple translation layer that allows x86_64 (Intel) binaries
# to run on Apple Silicon. Many older tools and SDKs still ship Intel-only
# binaries, so Rosetta 2 is essential for compatibility.
softwareupdate --install-rosetta --agree-to-license

# -----------------------------------------------------------------------------
# 5. Install Xcode Command Line Tools
# -----------------------------------------------------------------------------
# The Xcode Command Line Tools provide compilers (clang, gcc), make, and other
# essential build utilities required by many development packages. This is a
# lightweight alternative to installing the full Xcode IDE (~13 GB).
xcode-select --install

# -----------------------------------------------------------------------------
# 6. Install Node.js via NVM (Node Version Manager)
# -----------------------------------------------------------------------------
# NVM lets you install and switch between multiple Node.js versions easily.
# This is preferable to installing Node.js directly because different projects
# may require different Node versions.
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Load NVM into the current shell session so it is usable immediately.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install the latest Long-Term Support (LTS) version of Node.js.
# The LTS release is recommended for most production and development work
# because it receives long-term bug fixes and security patches.
nvm install --lts

# Set the installed LTS version as the default so every new terminal session
# automatically uses it.
nvm use --lts
nvm alias default 'lts/*'

# -----------------------------------------------------------------------------
# 7. Install Python via pyenv
# -----------------------------------------------------------------------------
# pyenv allows you to manage multiple Python versions side by side, similar to
# how NVM works for Node.js. This is useful when different projects require
# different Python versions.
brew install pyenv

# Add pyenv initialisation to the shell profile so it loads on every new
# terminal session.
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"'    >> ~/.zshrc
echo 'eval "$(pyenv init -)"'                  >> ~/.zshrc

# Install the latest stable Python 3 release and set it as the global default.
pyenv install 3.12.3
pyenv global  3.12.3

# Upgrade pip (Python's package manager) to the latest version so you can
# install third-party libraries without compatibility warnings.
pip install --upgrade pip

# -----------------------------------------------------------------------------
# 8. Install Visual Studio Code
# -----------------------------------------------------------------------------
# VS Code is a lightweight, highly extensible code editor with built-in support
# for Git, debugging, IntelliSense, and a large extension marketplace. It is
# one of the most popular editors for web, Python, and general development.
brew install --cask visual-studio-code

# Install the `code` CLI helper so you can open files and folders in VS Code
# directly from the terminal (e.g. `code .`).
cat << 'EOF' >> ~/.zshrc
# Open VS Code from the terminal
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
EOF

# -----------------------------------------------------------------------------
# 9. Install iTerm2 (Terminal Emulator)
# -----------------------------------------------------------------------------
# iTerm2 is a feature-rich replacement for the default macOS Terminal app. It
# offers split panes, search, autocomplete, triggers, and extensive
# customisation — making it a favourite among developers.
brew install --cask iterm2

# -----------------------------------------------------------------------------
# 10. Install Oh My Zsh (Zsh Framework)
# -----------------------------------------------------------------------------
# Oh My Zsh is a community-driven framework for managing Zsh configuration. It
# ships with hundreds of plugins and themes that improve productivity in the
# terminal (e.g. git shortcuts, auto-suggestions, syntax highlighting).
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# -----------------------------------------------------------------------------
# 11. Install zsh-autosuggestions Plugin
# -----------------------------------------------------------------------------
# zsh-autosuggestions shows command suggestions as you type, based on your
# command history. Pressing the right-arrow key (→) accepts the suggestion,
# dramatically speeding up repetitive tasks.
git clone https://github.com/zsh-users/zsh-autosuggestions \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# Enable the plugin by adding it to the plugins list in ~/.zshrc.
sed -i '' 's/plugins=(git)/plugins=(git zsh-autosuggestions)/' ~/.zshrc

# -----------------------------------------------------------------------------
# 12. Install zsh-syntax-highlighting Plugin
# -----------------------------------------------------------------------------
# zsh-syntax-highlighting colours your commands as you type them. Valid
# commands are highlighted in green and invalid ones in red, helping you catch
# typos before pressing Enter.
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

# Enable the plugin (must be the last plugin in the list).
sed -i '' 's/plugins=(git zsh-autosuggestions)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# -----------------------------------------------------------------------------
# 13. Install Docker Desktop
# -----------------------------------------------------------------------------
# Docker packages applications and their dependencies into isolated containers,
# ensuring consistent behaviour across development, staging, and production
# environments. Docker Desktop provides the GUI and the Docker daemon required
# to build and run containers on macOS.
brew install --cask docker

# -----------------------------------------------------------------------------
# 14. Install wget
# -----------------------------------------------------------------------------
# wget is a command-line utility for downloading files from the web. It
# supports HTTP, HTTPS, and FTP and is commonly used in scripts to fetch
# remote resources (e.g. install scripts, archives, datasets).
brew install wget

# -----------------------------------------------------------------------------
# 15. Install curl
# -----------------------------------------------------------------------------
# curl is a command-line tool for transferring data with URLs. It supports a
# wide range of protocols and is widely used to test REST APIs, download files,
# and send HTTP requests from the terminal or shell scripts.
brew install curl

# -----------------------------------------------------------------------------
# 16. Install jq
# -----------------------------------------------------------------------------
# jq is a lightweight command-line JSON processor. It lets you parse, filter,
# and format JSON output from APIs or configuration files directly in the
# terminal, making it indispensable for working with modern web services.
brew install jq

# -----------------------------------------------------------------------------
# 17. Install htop
# -----------------------------------------------------------------------------
# htop is an interactive process viewer for the terminal. It provides a
# real-time, colour-coded overview of running processes, CPU usage, memory
# consumption, and more — a more user-friendly alternative to the built-in
# `top` command.
brew install htop

# -----------------------------------------------------------------------------
# 18. Install tree
# -----------------------------------------------------------------------------
# tree displays the directory structure of a path as a visual tree. It is
# useful for quickly understanding a project's folder layout without opening
# a file manager or IDE.
brew install tree

# -----------------------------------------------------------------------------
# 19. Install tmux
# -----------------------------------------------------------------------------
# tmux is a terminal multiplexer that lets you create, manage, and persist
# multiple terminal sessions inside a single window. You can detach from a
# session, log out, and re-attach later — great for long-running processes on
# remote servers or for organising complex local workflows.
brew install tmux

# -----------------------------------------------------------------------------
# 20. Install Postman
# -----------------------------------------------------------------------------
# Postman is a graphical API development and testing tool. It lets you craft
# HTTP requests, inspect responses, write automated tests, and share API
# collections with your team — essential for backend and API development.
brew install --cask postman

# -----------------------------------------------------------------------------
# 21. Install Rectangle (Window Manager)
# -----------------------------------------------------------------------------
# Rectangle is a window management app for macOS that lets you snap, resize,
# and arrange windows using keyboard shortcuts or drag-to-edge gestures,
# helping you keep your desktop organised while multitasking.
brew install --cask rectangle

# -----------------------------------------------------------------------------
# 22. Install Java (via Homebrew OpenJDK)
# -----------------------------------------------------------------------------
# Java is required by many enterprise tools and frameworks (e.g. Apache Kafka,
# Elasticsearch, Android Studio). Installing it via Homebrew makes version
# management simple and keeps it off the system Java path.
brew install openjdk@21

# Add the OpenJDK binary directory to PATH so `java` and `javac` are found
# in the terminal.
echo 'export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"' >> ~/.zshrc
export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"

# -----------------------------------------------------------------------------
# 23. Install Go (Golang)
# -----------------------------------------------------------------------------
# Go is a statically typed, compiled language developed by Google. It is
# popular for building high-performance network services, CLI tools, and
# cloud-native applications (e.g. Docker, Kubernetes are written in Go).
brew install go

# Set the Go workspace directory (GOPATH) where Go binaries and packages are
# stored.
echo 'export GOPATH="$HOME/go"'            >> ~/.zshrc
echo 'export PATH="$PATH:$GOPATH/bin"' >> ~/.zshrc

# -----------------------------------------------------------------------------
# 24. Install Rust (via rustup)
# -----------------------------------------------------------------------------
# Rust is a systems programming language focused on safety, speed, and
# concurrency. rustup is the official Rust toolchain installer and version
# manager. It also installs cargo, Rust's build system and package manager.
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# -----------------------------------------------------------------------------
# 25. Install AWS CLI
# -----------------------------------------------------------------------------
# The AWS CLI lets you interact with Amazon Web Services from the terminal.
# It is used for deploying infrastructure, managing S3 buckets, invoking
# Lambda functions, and automating cloud workflows via scripts.
brew install awscli

# -----------------------------------------------------------------------------
# 26. Install Terraform
# -----------------------------------------------------------------------------
# Terraform by HashiCorp is an Infrastructure-as-Code (IaC) tool. It lets you
# define and provision cloud infrastructure (servers, databases, networks) in
# declarative configuration files, enabling repeatable and version-controlled
# deployments.
brew install terraform

# -----------------------------------------------------------------------------
# 27. Install kubectl
# -----------------------------------------------------------------------------
# kubectl is the command-line interface for Kubernetes. It lets you deploy
# applications, inspect cluster resources, view logs, and manage Kubernetes
# objects from the terminal.
brew install kubectl

# -----------------------------------------------------------------------------
# 28. Install Helm
# -----------------------------------------------------------------------------
# Helm is the package manager for Kubernetes. It simplifies deploying complex
# applications on Kubernetes by using pre-configured templates called "charts",
# reducing the need to write lengthy YAML manifests by hand.
brew install helm

# -----------------------------------------------------------------------------
# 29. Set macOS Defaults for Developers
# -----------------------------------------------------------------------------

# Show hidden files in Finder by default. Hidden files (those starting with a
# dot, e.g. .gitignore, .env) are important in development and are hidden by
# macOS by default.
defaults write com.apple.finder AppleShowAllFiles YES

# Show the full file path in the Finder window title bar, which helps you
# quickly know exactly where you are in the file system.
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Disable the automatic creation of .DS_Store files on network volumes and
# USB drives. These invisible files store folder metadata but are unnecessary
# and can clutter version control repositories.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores     -bool true

# Restart Finder to apply the above settings immediately.
killall Finder

# Disable press-and-hold for keys in favour of key repeat. When disabled,
# holding a key types the character repeatedly (useful for navigation in the
# terminal) instead of showing an accent picker popup.
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a fast keyboard repeat rate and a short delay before repeat starts,
# which makes cursor movement and text editing noticeably faster in the
# terminal and editors.
defaults write NSGlobalDomain KeyRepeat        -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# -----------------------------------------------------------------------------
# 30. Create Common Developer Directories
# -----------------------------------------------------------------------------
# Set up a standard folder structure under the home directory so that
# projects, scripts, and tools have a consistent, organised location.
mkdir -p ~/Developer/projects   # All personal and work projects live here
mkdir -p ~/Developer/scripts    # Reusable shell scripts and automation tools
mkdir -p ~/Developer/sandbox    # Throwaway experiments and spike projects

# -----------------------------------------------------------------------------
# 31. Apply Zsh Configuration Changes
# -----------------------------------------------------------------------------
# Reload ~/.zshrc so that all PATH updates, aliases, and plugin configurations
# added by this script take effect in the current terminal session without
# needing to open a new window.
source ~/.zshrc

# -----------------------------------------------------------------------------
# Done!
# -----------------------------------------------------------------------------
echo ""
echo "============================================================"
echo "  M1 MacBook Air developer environment setup is complete!"
echo "  Please restart your terminal (or open a new tab) to"
echo "  ensure all changes are fully applied."
echo "============================================================"
