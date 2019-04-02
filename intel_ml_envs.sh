# !/bin/bash
# Usage: bash intel_optimized_ml_envs.sh

# Add conda, activate to PATH
export PATH=/anaconda/envs/py35/bin:$PATH

# Add Intel channel to conda
conda config --add channels intel

# Create Python 2.7 TensorFlow env
yes 'y' | conda create -n intel_tensorflow_p27 -c intel python=2 numpy tensorflow keras
source activate intel_tensorflow_p27
export KMP_AFFINITY=granularity=fine,verbose,compact,1,0
export KMP_BLOCKTIME=1
export KMP_SETTINGS=1
export OMP_NUM_THREADS=$(lscpu | grep "Core(s) per socket" | cut -d':' -f2 | sed "s/ //g")
export OMP_PROC_BIND=true
source deactivate

# Create Python 3.6 TensorFlow env
yes 'y' | conda create -n intel_tensorflow_p36 -c intel python=3 numpy tensorflow keras
source activate intel_tensorflow_p36
export KMP_AFFINITY=granularity=fine,verbose,compact,1,0
export KMP_BLOCKTIME=1
export KMP_SETTINGS=1
export OMP_NUM_THREADS=$(lscpu | grep "Core(s) per socket" | cut -d':' -f2 | sed "s/ //g")
export OMP_PROC_BIND=true
source deactivate

# Create Python 2.7 MXNet env
yes 'y' | conda create -n intel_mxnet_p27 -c intel python=2 numpy opencv Pillow scipy scikit-learn mxnet-mkl keras
source activate intel_mxnet_p27
export LD_LIBRARY_PATH=/usr/local/lib
export OMP_NUM_THREADS=$(lscpu | grep "Core(s) per socket" | cut -d':' -f2 | sed "s/ //g")
export KMP_AFFINITY=granularity=fine,compact,1,0
export KMP_BLOCKTIME=1
export OMP_PROC_BIND=true
source deactivate

# Create Python 3.6 MXNet env
yes 'y' | conda create -n intel_mxnet_p36 -c intel python=3 numpy opencv Pillow scipy scikit-learn mxnet-mkl keras
export LD_LIBRARY_PATH=/usr/local/lib
export OMP_NUM_THREADS=$(lscpu | grep "Core(s) per socket" | cut -d':' -f2 | sed "s/ //g")
export KMP_AFFINITY=granularity=fine,compact,1,0
export KMP_BLOCKTIME=1
export OMP_PROC_BIND=true
source deactivate
