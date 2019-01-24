# !/bin/bash
# Run TensorFlow's tf_cnn benchmarks
# This file is called by tf_multiworker.sh

###################################################################################
# If running the Intel Optimized benchmark, follow instructions  below

# Uncomment to activate the appropriate virtual environment
# source activate your_intel_optimized_env

# On line 35, change the --data_format flag to NCHW 

###################################################################################

###################################################################################
# If running the default benchmark, leave everything above commented out and change
# the --data_format flag to NHWC

###################################################################################

# Clone benchmark scripts
git clone -b mkl_experiment https://github.com/tensorflow/benchmarks.git
cd benchmarks/scripts/tf_cnn_benchmarks
rm *.log # remove logs from any previous benchmark runs

## Run training benchmark scripts

networks=( inception3 resnet50 resnet152 vgg16 )
batch_sizes=( 32 64 96 128 )

for network in "${networks[@]}" ; do
  for bs in "${batch_sizes[@]}"; do
    echo -e "\n\n #### Starting $network and batch size = $bs ####\n\n"

    time python tf_cnn_benchmarks.py --data_format NCHW --data_name synthetic --model "$network" --forward_only False -batch_size "$bs" --num_batches 50 2>&1 | tee net_"$network"_bs_"$bs".log

  done
done

# Deactivate virtual environment
source deactivate
