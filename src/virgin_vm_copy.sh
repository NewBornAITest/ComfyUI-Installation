#!/bin/bash

# Update system & install dependencies
sudo apt-get update
sudo apt-get --assume-yes upgrade
sudo apt-get --assume-yes install software-properties-common jq build-essential linux-headers-$(uname -r)

# Install Miniconda (if not already installed)
if [ ! -d "$HOME/miniconda3" ]; then
    echo "Installing Miniconda..."
    wget https://repo.anaconda.com/miniconda/Miniconda3-py310_23.11.0-2-Linux-x86_64.sh
    chmod +x Miniconda3-py310_23.11.0-2-Linux-x86_64.sh
    ./Miniconda3-py310_23.11.0-2-Linux-x86_64.sh -b -p $HOME/miniconda3
else
    echo "Miniconda already installed."
fi

# Ensure Miniconda is initialized
export PATH="$HOME/miniconda3/bin:$PATH"
source $HOME/miniconda3/bin/activate

# Confirm Miniconda installation
echo "Checking Python and Pip..."
which python
which pip

# Check if an NVIDIA GPU is available
if command -v nvidia-smi &> /dev/null; then
    echo "GPU detected:"
    nvidia-smi
else
    echo "No GPU found. Installing NVIDIA drivers & CUDA..."
    
    # Add CUDA repository & install NVIDIA drivers
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
    sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600

    wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-ubuntu2004-11-8-local_11.8.0-520.61.05-1_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu2004-11-8-local_11.8.0-520.61.05-1_amd64.deb
    sudo cp /var/cuda-repo-ubuntu2004-11-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
    
    # Install CUDA
    sudo apt-get update
    sudo apt-get -y install cuda
fi

# Install PyTorch with CUDA support
echo "Installing PyTorch..."
pip install --no-cache-dir torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu118

# Test CUDA availability safely
echo "Testing CUDA availability..."
echo -e "import torch\nprint(torch.cuda.is_available())" > test_cuda.py
CUDA_AVAILABLE=$(python test_cuda.py | tail -1)

if [[ "$CUDA_AVAILABLE" == "True" ]]; then
    echo "CUDA is available!"
    python -c "import torch; print(torch.cuda.get_device_name(0))"
else
    echo "CUDA is NOT available. Skipping CUDA tests."
fi
