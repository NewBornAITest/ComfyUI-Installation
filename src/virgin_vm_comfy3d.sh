#!/bin/bash

sudo apt-get update
sudo apt-get --assume-yes upgrade
sudo apt-get --assume-yes install software-properties-common
sudo apt-get --assume-yes install jq
sudo apt-get --assume-yes install build-essential
sudo apt-get --assume-yes install linux-headers-$(uname -r)
wget https://repo.anaconda.com/miniconda/Miniconda3-py312_23.11.0-2-Linux-x86_64.sh
chmod +x Miniconda3-py312_23.11.0-2-Linux-x86_64.sh
./Miniconda3-py312_23.11.0-2-Linux-x86_64.sh -b -p $HOME/miniconda3
~/miniconda3/bin/conda init bash
source .bashrc
# confirm GPU is attached
lspci | grep -i nvidia
# confirm GPU not recognized
nvidia-smi
# install nvidia drivers and CUDA
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
wget https://developer.download.nvidia.com/compute/cuda/12.4.0/local_installers/cuda-repo-ubuntu2204-12-4-local_12.4.0-535.86.10-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2204-12-4-local_12.4.0-535.86.10-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-12-4-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda

source .bashrc
source .bashrc
pip install torch==2.5.1 torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu124
echo -e "import torch\nprint(torch.cuda.is_available())\nprint(torch.cuda.get_device_name(0))" > test_cuda.py
python test_cuda.py
