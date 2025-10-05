#!/bin/bash

set -e

echo "🚀 Starting Docker APT repository setup and installation..."

# Update system and install required dependencies
echo "🔧 Installing prerequisites..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# Create keyrings directory
echo "📁 Creating keyring directory..."
sudo install -m 0755 -d /etc/apt/keyrings

# Add Docker's official GPG key
echo "🔑 Downloading Docker GPG key..."
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker's repository to Apt sources
echo "📚 Adding Docker APT repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list
echo "🔄 Updating package list..."
sudo apt-get update

# Install Docker Engine and related components
echo "🐳 Installing Docker components..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable and start Docker service
echo "🟢 Enabling and starting Docker..."
sudo systemctl enable docker
sudo systemctl start docker

# Optional: Add current user to docker group (avoids needing sudo)
echo "👤 Adding user '$USER' to docker group..."
sudo usermod -aG docker $USER

echo ""
echo "✅ Docker installation complete!"
echo "ℹ️ Please log out and back in (or reboot) to apply group changes."
echo "📦 Test Docker with: docker run hello-world"
