#!/bin/bash

echo -e "check nvidia"

# confirm GPU is attached
lspci | grep -i nvidia
# confirm GPU not recognized
nvidia-smi