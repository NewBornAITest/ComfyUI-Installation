#!/bin/bash

# Define your Hugging Face access token here
ACCESS_TOKEN="YOUR_ACCESS_TOKEN"

# Define the base models directory
BASE_DIR="models"

# Create the required folders
mkdir -p "$BASE_DIR/unet"
mkdir -p "$BASE_DIR/clip"
mkdir -p "$BASE_DIR/vae"
mkdir -p "$BASE_DIR/loras"

# Download the files
echo "Downloading models..."

# Unet model
wget --header="Authorization: Bearer $ACCESS_TOKEN" \
    -O "$BASE_DIR/unet/flux1-dev.safetensors" \
    "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors"

# Clip models
wget --header="Authorization: Bearer $ACCESS_TOKEN" \
    -O "$BASE_DIR/clip/clip_l.safetensors" \
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors"

wget --header="Authorization: Bearer $ACCESS_TOKEN" \
    -O "$BASE_DIR/clip/t5xxl_fp16.safetensors" \
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors"

wget --header="Authorization: Bearer $ACCESS_TOKEN" \
    -O "$BASE_DIR/clip/t5xxl_fp8_e4m3fn.safetensors" \
    "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors"

# VAE model
wget --header="Authorization: Bearer $ACCESS_TOKEN" \
    -O "$BASE_DIR/vae/ae.safetensors" \
    "https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors"

# Loras models (recursive download of the entire folder)
wget --header="Authorization: Bearer $ACCESS_TOKEN" \
    --recursive --no-parent --cut-dirs=1 --reject "index.html*" --no-host-directories \
    -P "$BASE_DIR/loras" \
    "https://huggingface.co/comfyanonymous/flux_RealismLora_converted_comfyui/tree/main"

echo "Download complete!"
