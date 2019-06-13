# !/bin/bash
# Usage: bash custom_ml_envs.sh

# Note: in conda 4.6, the post-activate file is sourced every
# time conda is run, not just every time we activate the 
# environment, as in 4.3.

# Add conda, activate to PATH
export PATH=/data/anaconda/envs/py35/bin/:$PATH

# Add Intel channel to conda
conda config --add channels intel


#### Create Python 3 TensorFlow env ####
yes 'y' | conda create -n intel_tensorflow_p3 -c intel python=3 

# Create a post-activate script to install all packages
source activate intel_tensorflow_p3
export LOCATION=$CONDA_PREFIX
mkdir -p $LOCATION/etc/conda/activate.d/
touch $LOCATION/etc/conda/activate.d/install_tf3.sh

# Write install instructions to post-activate file
cat <<EOT >> $LOCATION/etc/conda/activate.d/install_tf3.sh
# !/bin/bash
# Check if TensorFlow is already installed
if conda list | grep -q 'intel-tensorflow';
then
    :
else
    echo "Installing Intel Optimized TensorFlow..."
    echo "This is a one-time installation, and may take a minute..."
    export KMP_AFFINITY=granularity=fine,noverbose,compact,1,0
    export KMP_BLOCKTIME=1
    export KMP_SETTINGS=1
    export OMP_NUM_THREADS=$(lscpu | grep "Core(s) per socket" | cut -d':' -f2 | sed "s/ //g")
    export OMP_PROC_BIND=true
    conda install -y tensorflow keras
fi

EOT
conda deactivate


#### Create Python 3 MXNet env ####
yes 'y' | conda create -n intel_mxnet_p3 -c intel python=3 

# Create a post-activate script to install all packages
source activate intel_mxnet_p3
export LOCATION=$CONDA_PREFIX
mkdir -p $LOCATION/etc/conda/activate.d/
touch $LOCATION/etc/conda/activate.d/install_mx3.sh

# Write install instructions to post-activate file
cat <<EOT >> $LOCATION/etc/conda/activate.d/install_mx3.sh
# !/bin/bash
# Check if MXNet is already installed
if conda list | grep -q 'mxnet-mkl';
then
    :
else
    echo "Installing Intel Optimized MXNet..."
    echo "This is a one-time installation, and may take a minute..."
    export KMP_AFFINITY=granularity=fine,noverbose,compact,1,0
    export KMP_BLOCKTIME=1
    export KMP_SETTINGS=1
    export OMP_NUM_THREADS=$(lscpu | grep "Core(s) per socket" | cut -d':' -f2 | sed "s/ //g")
    export OMP_PROC_BIND=true
    conda install -y mxnet-mkl
fi

EOT
conda deactivate


#### Create Python 3 PyTorch env ####
## Must build the environment with supporting packages first - doesn't add much extra time
yes 'y' | conda create -n intel_pytorch_p3 -c intel python=3 numpy pyyaml mkl mkl-include setuptools cmake cffi typing

# Create a post-activate script to install all packages
source activate intel_pytorch_p3
export LOCATION=$CONDA_PREFIX
mkdir -p $LOCATION/etc/conda/activate.d/
touch $LOCATION/etc/conda/activate.d/install_pt3.sh

# Write install instructions to post-activate file
cat <<EOT >> $LOCATION/etc/conda/activate.d/install_pt3.sh
# !/bin/bash
# Check if PyTorch is already installed
if conda list | grep -q '^torch';
then
    :
else
    echo "Installing Intel Optimized PyTorch..."
    echo "This is a one-time installation, and may take a minute..."
    export NO_CUDA=1
    export CMAKE_PREFIX_PATH=~/data/anaconda/
    git clone --recursive https://github.com/intel/pytorch
    cd pytorch
    python setup.py install
    cd
    export KMP_AFFINITY=granularity=fine,noverbose,compact,1,0
    export KMP_BLOCKTIME=1
    export KMP_SETTINGS=1
    export OMP_NUM_THREADS=$(lscpu | grep "Core(s) per socket" | cut -d':' -f2 | sed "s/ //g")
    export OMP_PROC_BIND=true
fi

EOT
conda deactivate
