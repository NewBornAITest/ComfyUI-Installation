#!/bin/bash

pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu118
git clone https://github.com/NewBornAITest/ComfyUI-NB.git
pip install -r ComfyUI-NB/requirements.txt

# make it work as if it doesnt run.