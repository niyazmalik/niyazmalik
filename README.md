## Linux (Ubuntu/Debian)
```bash
# Update package list
sudo apt update

# Install build tools
sudo apt install -y build-essential

# Install Git
sudo apt install -y git

# Install ripgrep
sudo apt install -y ripgrep

# Install Neovim (via snap for latest version)
sudo snap install nvim --classic

# OR install via apt (might be older version)
# sudo apt install -y neovim

# Install Node.js via nvm (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Restart terminal or run:
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install Node.js
nvm install 20 (or any version)
nvm use 20
nvm alias default 20
```
