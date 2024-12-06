## How to Install? (Takes only 15 mins!) <a name="installation"></a>

1. Create a GCP compute engine instance(VM) and Install the google CLI on your local machine(***details below***).
2. Log in to your VM and execute the following commands:

    ```bash
    git clone https://github.com/NewBornAITest/ComfyUI-Installation.git
    chmod +x ./ComfyUI-Installation/src/install.sh
    chmod +x ./ComfyUI-Installation/src/virgin_vm.sh
  
    ./ComfyUI-Installation/src/virgin_vm.sh # run this only for new VM. This will install miniconda, cuda 11.8, torch.  
    source ~/.bashrc 
    ./ComfyUI-Installation/src/install.sh
    ```

    This will set up comfyUI, install popular extensions and model checkpoints, and include an automation script that automatically starts the comfyvm server whenever the VM is booted.


## Detailed Tutorial   <a name="instructions_details"></a>

### 1. Creating a Linux VM with GPU Support and Authenticating Your Local Machine

1. **Create a Google Cloud Platform account** and activate the compute engine. 
2. **Upgrading to a paid account** (Search "billing accounts")
3. **Increase GPU quota** from 0 to 1 via Quotas & System Limits (search GPUs (all regions) inside the Quotas & System Limits )
4. **Create an Ubuntu 20.04 VM** with T4 GPU and add a TCP firewall rule for port 8188. (name your instance comfyvm, choose zone as europe-central2-b and make sure add your firewall port8188 tag in the network section  )
5. **Open terminal in your local machine and Install the gcloud CLI**:

    ```bash
    wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-461.0.0-darwin-arm.tar.gz
    tar -xzvf google-cloud-cli-461.0.0-darwin-arm.tar.gz
    ./google-cloud-sdk/install.sh
    # for windows simply download the gcloud from the link below and run it
    # https://cloud.google.com/sdk/docs/install#windows
    ```

    If there are issues with the `gcloud` command, add the following to your `~/.bash_profile`, adjusting the paths as necessary:

    ```bash
    if [ -f '/Users/your_username/projects/google-cloud-sdk/path.bash.inc' ]; then . '/Users/your_username/projects/google-cloud-sdk/path.bash.inc'; fi
    if [ -f '/Users/your_username/projects/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/your_username/projects/google-cloud-sdk/completion.bash.inc'; fi
    ```

6. **Authenticate using gcloud** on your local machine:

    ```bash
   gcloud auth login
    gcloud init
    ```

7. **Generate new SSH key pairs** on your local machine:

    ```bash
    ssh-keygen -t rsa -b 2048 -C "comfy_vm_key" -f ~/.ssh/comfy_vm_key
    # for windows, run the below commands instead:
    # mkdir "$HOME\.ssh"
    # ssh-keygen -t rsa -b 2048 -C "comfy_vm_key" -f "$HOME\.ssh\comfy_vm_key"
    ```
     
    This creates `.ssh/comfy_vm_key.pub` and `.ssh/comfy_vm_key` files.

8. **Authenticate the VM with your SSH key pairs** and log in from your local machine to the VM:

    ```bash
    cd ~/.ssh
    gcloud compute os-login ssh-keys add --key-file=comfy_vm_key.pub
    gcloud compute ssh comfyvm --zone europe-central2-b
    #  if you got error and try running this line  "gcloud compute config-ssh "   and then run "gcloud compute ssh comfyvm"
    #  if this doesnt work too, run "gcloud compute config-ssh --remove" and "rm ~/.ssh/authorized_keys" and run "gcloud init" and try to connect again
    ```
### 2.Setting up ComfyUI Server

1. Log in to the VM:

    ```bash
    gcloud compute ssh comfyvm --zone europe-central2-b
    
    ```

2. Clone the repo for ComfyUI installation scripts and execute them:

    ```bash
    git clone https://github.com/karaposu/comfyui-on-cloud
    chmod +x ./comfyui-on-cloud/src/install.sh
    chmod +x ./comfyui-on-cloud/src/virgin_vm.sh
  
    ./comfyui-on-cloud/src/virgin_vm.sh # run this only for new VM. This will install miniconda, cuda 11.8, torch.  
    source ~/.bashrc 
    ./comfyui-on-cloud/src/install.sh
    ```

    This process will automatically install a startup runner for the server and start the server. You can verify the installation by accessing `[external-ip-of-your-vm]:8188` in your browser to check if everything is working correctly.
