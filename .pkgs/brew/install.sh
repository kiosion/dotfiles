#!/bin/bash

# Install xcode cmd-line tools
xcode-select --install

# Clone & install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew analytics off
