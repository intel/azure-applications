# Intel + Azure

--Under Construction--

This repo contains code and instructions for launching an [Azure Data Science Virtual Machine for Linux (Ubuntu or CentOS)](https://azure.microsoft.com/en-us/services/virtual-machines/data-science-virtual-machines/) with pre-built deep learning environments optimized for execution on Intel CPUs.

Instructions are organized into two sections:

1. Launch via the Azure Marketplace (simplest option)
2. Launch via the Azure CLI, and
3. Launch manually via the Azure portal

##1. Launch via the Azure Marketplace

Please see our recent blog post [needs link] for instructions on launching from the Azure Marketplace. 

##2. Quick Launch Using Azure Cloud Shell
Launch [Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview) and choose PowerShell from the shell dropdown. 
Run the following commands to launch a DSVM with Intel optimized deep learning frameworks.

```
wget https://raw.githubusercontent.com/MattsonThieme/intel-envs/master/parameters.json

az group create --location <location> --name <myResourceGroup>

az group deployment create --resource-group <myResourceGroup> \
--template-uri https://raw.githubusercontent.com/MattsonThieme/intel-envs/master/template.json \
--parameters parameters.json \
--parameters adminUsername=<adminUsername> adminPassword=<myPassword>

```

## Launch from your local machine

1. [Install Azure CLI.](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) We recommend to run Azure CLI in [Docker container](https://docs.microsoft.com/en-us/cli/azure/run-azure-cli-docker?view=azure-cli-latest) 
    * `docker run -it microsoft/azure-cli`

1. Authorize your machine by signing in
    * `az login`

1. List resource groups and create a new resource group, if needed. See [Microsoft's documentation](https://docs.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest#examples) for additional info and examples.
    * `az group list -o table`
    * `az group create --location <location> --name <name>`
    
1.  Download `parameters.json` file as it is required in the next step.
    ```
    wget https://raw.githubusercontent.com/MattsonThieme/intel-envs/master/parameters.json
    ```
1. Create a DSVM with Intel optimized DL frameworks. Use your resource group, admin username, admin password, and VM name as shown:
    ```
    az group deployment create --resource-group <myResourceGroup> \
    --template-uri https://raw.githubusercontent.com/MattsonThieme/intel-envs/master/template.json \
    --parameters parameters.json \
    --parameters adminUsername=<adminUsername> adminPassword=<myPassword> virtualMachineName=<myName>
    ```
1. To connect to your virtual machine, run:
	```
	az vm show --resource-group <myResourceGroup> \
    --name <myVirtualMachineName> \
    --show-details --query publicIps --output tsv
    ```
    This will display the IP address, at which point you may connect with 
    `ssh <adminUsername>@<ipAddress>`

1. **NOTE:** Azure allows users to connect to the VM before the custom extension has completed installing the Intel Optimized virtual environments. If some virtual environments (TensorFlow and MXNet for python 2.7 and 3.6) are not shown in `conda env list`, please wait a minute and check again.

