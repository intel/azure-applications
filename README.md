# Intel Optimized Azure Data Science Virtual Machine for Linux (Ubuntu)

This repo contains code and instructions for launching a pre-configured [Azure Data Science Virtual Machine for Linux](https://azure.microsoft.com/en-us/services/virtual-machines/data-science-virtual-machines/) with CPU-optimized TensorFlow and MXNet (more coming soon).

The Intel® Optimized Data Science Virtual Machine (DSVM) is an extension of the Ubuntu version of Microsoft's DSVM and comes with Python environments optimized for deep learning on Intel® Xeon® Processors. These environments include open source deep learning frameworks with Intel® MKL-DNN as a backend for optimal performance on Intel® Xeon Processors. These environments require no changes to existing code and accelerate deep learning training and inference. Additionally, this offering includes all software packages available on the base DSVM with several popular tools for data science and ML which are already pre-installed, configured and tested. For more info, click [here](https://azure.microsoft.com/en-us/services/virtual-machines/data-science-virtual-machines/ "https://azure.microsoft.com/en-us/services/virtual-machines/data-science-virtual-machines/"). For additional information on Intel® Optimizations for deep learning frameworks, please click [here](https://www.intel.ai/framework-optimizations/)

#### Recommended VM Sizes:

-   Compute Optimized: Fsv2-series (F4sv2, F8sv2, F16sv2, F32sv2, F64sv2, F72sv2)
-   High Performance Compute: Hc-series

#### Launch via the Azure Marketplace:

Search for _Intel Optimized Data Science VM for Linux (Ubuntu)_ at [Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/) and click **GET IT NOW** and follow the prompts to launch the VM. 

**Note:**  This VM takes about 10 minutes to launch. At creation, a custom extension triggers a one-time installation of the latest Intel® Optimized deep learning frameworks. Once launched, you will be able to start and stop the VM as usual.
Instructions are organized into two sections:

#### Usage:

-  Display available virtual environments with `conda env list`
-   Activate the desired virtual environment with `source activate <env_name>` (ex: `source activate intel_tensorflow_p36`)
-   To run **benchmarks**, follow instructions [here](https://github.com/IntelAI/azure-applications/blob/master/scripts/benchmark/intel_tf_cnn_benchmarks.sh)
