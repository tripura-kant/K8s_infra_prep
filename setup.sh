#!/bin/bash

set -e

echo "📦 Updating system packages..."
sudo dnf update -y

echo "🐳 Installing Docker..."
sudo dnf install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

echo "🔄 Docker installed. You may need to 'newgrp docker' or re-login for group changes to apply."

echo "⚙️ Installing kubectl (latest stable)..."
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

echo "🛠️ Installing Kind (v0.22.0)..."
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
kind version

echo "🚀 Creating a Kind cluster..."
# Re-evaluate groups in the current shell if possible
newgrp docker <<EOF
kind create cluster
EOF

echo "✅ Kind cluster created successfully."
kubectl get nodes
