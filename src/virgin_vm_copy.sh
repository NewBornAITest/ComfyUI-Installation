#!/bin/bash

# Update system & install dependencies
sudo apt-get update
sudo apt-get --assume-yes upgrade
sudo apt-get --assume-yes install software-properties-common jq build-essential linux-headers-$(uname -r)

# Install Miniconda (if not already installed)
if [ ! -d "$HOME/miniconda3" ]; then
    wget https://repo.anaconda.com/miniconda/Miniconda3-py310_23.11.0-2-Linux-x86_64.sh
    chmod +x Miniconda3-py310_23.11.0-2-Linux-x86_64.sh
    ./Miniconda3-py310_23.11.0-2-Linux-x86_64.sh -b -p $HOME/miniconda3
fi

# Ensure Miniconda is initialized
export PATH="$HOME/miniconda3/bin:$PATH"
source $HOME/miniconda3/bin/activate

# Confirm Miniconda installation
which python
which pip

# Install PyTorch
pip install --no-cache-dir torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu118

# Test CUDA availability
echo -e "import torch\nprint(torch.cuda.is_available())\nprint(torch.cuda.get_device_name(0))" > test_cuda.py
python test_cuda.py
