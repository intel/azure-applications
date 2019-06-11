# !/bin/bash
# Usage: bash intel_optimized_ml_envs.sh

# Add conda, activate to PATH
export PATH=/anaconda/envs/py35/bin:$PATH

# Add Intel channel to conda
conda config --add channels intel


#### Create Python 2.7 TensorFlow env ####
yes 'y' | conda create -n intel_tensorflow_p27 -c intel python=2

# Create a post-activate script to install all packages
source activate intel_tensorflow_p27
export LOCATION=$CONDA_PREFIX
mkdir -p $LOCATION/etc/conda/activate.d/
touch $LOCATION/etc/conda/activate.d/install_tf27.sh

# Write install instructions to post-activate file
cat <<EOT >> $LOCATION/etc/conda/activate.d/install_tf27.sh
# !/bin/bash
# Check if TensorFlow is already installed
if conda list | grep 'tensorflow-base';
then
    :
else
    echo "Installing Intel Optimized TensorFlow..."
    echo "This is a one-time installation, and may take a minute..."
    conda install -y numpy tensorflow keras
    export KMP_AFFINITY=granularity=fine,verbose,compact,1,0
    export KMP_BLOCKTIME=1
    export KMP_SETTINGS=1
    export OMP_NUM_THREADS=$(lscpu | grep "Core(s) per socket" | cut -d':' -f2 | sed "s/ //g")
    export OMP_PROC_BIND=true
    echo "This environment is ready to use!"
fi

EOT
source deactivate


#### Create Python 3.6 TensorFlow env ####
yes 'y' | conda create -n intel_tensorflow_p36 -c intel python=3 

# Create a post-activate script to install all packages
source activate intel_tensorflow_p36
export LOCATION=$CONDA_PREFIX
mkdir -p $LOCATION/etc/conda/activate.d/
touch $LOCATION/etc/conda/activate.d/install_tf36.sh

# Write install instructions to post-activate file
cat <<EOT >> $LOCATION/etc/conda/activate.d/install_tf36.sh
# !/bin/bash
# Check if TensorFlow is already installed
if conda list | grep 'tensorflow-base';
then
    :
else
    echo "Installing Intel Optimized TensorFlow..."
    echo "This is a one-time installation, and may take a minute..."
    conda install -y numpy tensorflow keras
    export KMP_AFFINITY=granularity=fine,verbose,compact,1,0
    export KMP_BLOCKTIME=1
    export KMP_SETTINGS=1
    export OMP_NUM_THREADS=$(lscpu | grep "Core(s) per socket" | cut -d':' -f2 | sed "s/ //g")
    export OMP_PROC_BIND=true
    echo "This environment is ready to use!"
fi

EOT
source deactivate


#### Create Python 2.7 MXNet env ####
yes 'y' | conda create -n intel_mxnet_p27 -c intel python=2 

# Create a post-activate script to install all packages
source activate intel_mxnet_p27
export LOCATION=$CONDA_PREFIX
mkdir -p $LOCATION/etc/conda/activate.d/
touch $LOCATION/etc/conda/activate.d/install_mx27.sh

# Write install instructions to post-activate file
cat <<EOT >> $LOCATION/etc/conda/activate.d/install_mx27.sh
# !/bin/bash
# Check if MXNet is already installed
if conda list | grep 'mxnet-mkl';
then
    :
else
    echo "Installing Intel Optimized MXNet..."
    echo "This is a one-time installation, and may take a minute..."
    conda install -y numpy opencv Pillow scipy scikit-learn mxnet-mkl keras
    export KMP_AFFINITY=granularity=fine,verbose,compact,1,0
    export KMP_BLOCKTIME=1
    export KMP_SETTINGS=1
    export OMP_NUM_THREADS=$(lscpu | grep "Core(s) per socket" | cut -d':' -f2 | sed "s/ //g")
    export OMP_PROC_BIND=true
    echo "This environment is ready to use!"
fi

EOT
source deactivate


#### Create Python 2.7 MXNet env ####
yes 'y' | conda create -n intel_mxnet_p36 -c intel python=3 

# Create a post-activate script to install all packages
source activate intel_mxnet_p36
export LOCATION=$CONDA_PREFIX
mkdir -p $LOCATION/etc/conda/activate.d/
touch $LOCATION/etc/conda/activate.d/install_mx36.sh

# Write install instructions to post-activate file
cat <<EOT >> $LOCATION/etc/conda/activate.d/install_mx36.sh
# !/bin/bash
# Check if MXNet is already installed
if conda list | grep 'mxnet-mkl';
then
    :
else
    echo "Installing Intel Optimized MXNet..."
    echo "This is a one-time installation, and may take a minute..."
    conda install -y numpy opencv Pillow scipy scikit-learn mxnet-mkl keras
    export KMP_AFFINITY=granularity=fine,verbose,compact,1,0
    export KMP_BLOCKTIME=1
    export KMP_SETTINGS=1
    export OMP_NUM_THREADS=$(lscpu | grep "Core(s) per socket" | cut -d':' -f2 | sed "s/ //g")
    export OMP_PROC_BIND=true
    echo "This environment is ready to use!"
fi

EOT
source deactivate


#### Create Python 2.7 PyTorch env ####
yes 'y' | conda create -n intel_pytorch_p27 -c intel python=2 

# Create a post-activate script to install all packages
source activate intel_pytorch_p27
export LOCATION=$CONDA_PREFIX
mkdir -p $LOCATION/etc/conda/activate.d/
touch $LOCATION/etc/conda/activate.d/install_pt27.sh

# Write install instructions to post-activate file
cat <<EOT >> $LOCATION/etc/conda/activate.d/install_pt27.sh
# !/bin/bash
# Check if PyTorch is already installed
if conda list | grep 'mxnet-mkl';
then
    :
else
    echo "Installing Intel Optimized PyTorch..."
    echo "This is a one-time installation, and may take a minute..."
    conda install -y pip numpy pyyaml mkl mkl-include setuptools cmake cffi typing
    git clone --recursive https://github.com/intel/pytorch
    export NO_CUDA=1
    export CMAKE_PREFIX_PATH=~/anaconda3/
    cd pytorch
    python setup.py install
    export KMP_AFFINITY=granularity=fine,verbose,compact,1,0
    export KMP_BLOCKTIME=1
    export KMP_SETTINGS=1
    export OMP_NUM_THREADS=$(lscpu | grep "Core(s) per socket" | cut -d':' -f2 | sed "s/ //g")
    export OMP_PROC_BIND=true
    echo "This environment is ready to use!"
fi

EOT
source deactivate


#### Create Python 2.7 PyTorch env ####
yes 'y' | conda create -n intel_pytorch_p36 -c intel python=3 

# Create a post-activate script to install all packages
source activate intel_pytorch_p36
export LOCATION=$CONDA_PREFIX
mkdir -p $LOCATION/etc/conda/activate.d/
touch $LOCATION/etc/conda/activate.d/install_pt36.sh

# Write install instructions to post-activate file
cat <<EOT >> $LOCATION/etc/conda/activate.d/install_pt36.sh
# !/bin/bash
# Check if PyTorch is already installed
if conda list | grep 'mxnet-mkl';
then
    :
else
    echo "Installing Intel Optimized PyTorch..."
    echo "This is a one-time installation, and may take a minute..."
    conda install -y pip numpy pyyaml mkl mkl-include setuptools cmake cffi typing
    git clone --recursive https://github.com/intel/pytorch
    export NO_CUDA=1
    export CMAKE_PREFIX_PATH=~/anaconda3/
    cd pytorch
    python setup.py install
    export KMP_AFFINITY=granularity=fine,verbose,compact,1,0
    export KMP_BLOCKTIME=1
    export KMP_SETTINGS=1
    export OMP_NUM_THREADS=$(lscpu | grep "Core(s) per socket" | cut -d':' -f2 | sed "s/ //g")
    export OMP_PROC_BIND=true
    echo "This environment is ready to use!"
fi

EOT
source deactivate
