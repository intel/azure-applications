#!/bin/bash
#
# Copyright (c) 2019 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

####### USAGE #########
# bash intel_tf_cnn_benchmarks.sh <all> 
# 
# By default, this runs only InceptionV3 at batch size 128. Pass "all" argument 
# to run all networks and batch sizes in the benchmarking suite.
# 
# This script runs training with TensorFlow's CNN Benchmarks and summarizes 
# throughput increases when using Intel optimized TensorFlow.

# Note: you may need to edit benchmarks/scripts/tf_cnn_benchmarks/datasets.py to 
# import _pickle instead of Cpickle

# Set number of batches
num_batches=( 30 )

# Check if "all" option was passed, set networks and batch sizes accordingly
option=$1
if [ -z $option ]
then
  networks=( inception3 )
  batch_sizes=( 128 )
else
  networks=( inception3 resnet50 resnet152 vgg16 )
  batch_sizes=( 32 64 128 )
fi

# Set path to conda 
export PATH=/data/anaconda/envs/py35/bin/:$PATH

# Check TF version so that we clone the right benchmarks
conda activate intel_tensorflow_p36
export tfversion=$(python -c "import tensorflow as tf;print(tf.__version__)")
conda deactivate
arr=(${tfversion//./ })  # Parse version and release
export version=${arr[0]}
export release=${arr[1]}

# Clone benchmark scripts for appropriate TF version
git clone -b cnn_tf_v${version}.${release}_compatible  https://github.com/tensorflow/benchmarks.git
cd benchmarks/scripts/tf_cnn_benchmarks
rm *.log # remove logs from any previous benchmark runs

## Run benchmark scripts in the default environment
# Activate the default env
conda activate py35

for network in "${networks[@]}" ; do
  for bs in "${batch_sizes[@]}"; do
    echo -e "\n\n #### Starting $network and batch size = $bs ####\n\n"

    time python tf_cnn_benchmarks.py \
    --data_format NHWC \
    --data_name imagenet \
    --device cpu \
    --model "$network" \
    --batch_size "$bs" \
    --num_batches "$num_batches" \
    2>&1 | tee net_"$network"_bs_"$bs"_default.log

  done
done

# Deactivate the default env
conda deactivate 

## Run benchmark scripts in the Intel Optimized environment
conda activate intel_tensorflow_p36

for network in "${networks[@]}" ; do
  for bs in "${batch_sizes[@]}"; do
    echo -e "\n\n #### Starting $network and batch size = $bs ####\n\n"

    time python tf_cnn_benchmarks.py \
    --data_format NCHW \
    --data_name imagenet \
    --device cpu \
    --mkl=True \
    --model "$network" \
    --batch_size "$bs" \
    --num_batches "$num_batches" \
    2>&1 | tee net_"$network"_bs_"$bs"_optimized.log

  done
done

conda deactivate

## Print a summary of training throughputs and relative speedups across all networks/batch sizes

speedup_track=0
runs=0

# Set headers
echo $'\n\n\n\n'
echo "######### Executive Summary #########"
echo $'\n'
echo "Environment |  Network   | Batch Size | Images/Second"
echo "--------------------------------------------------------"
for network in "${networks[@]}" ; do
  for bs in "${batch_sizes[@]}"; do
    default_fps=$(grep  "total images/sec:"  net_"$network"_bs_"$bs"_default.log | cut -d ":" -f2 | xargs)
    optimized_fps=$(grep  "total images/sec:"  net_"$network"_bs_"$bs"_optimized.log | cut -d ":" -f2 | xargs)
    echo "Default     | $network |     $bs     | $default_fps"
    echo "Optimized   | $network |     $bs     | $optimized_fps"
    speedup=$((${optimized_fps%.*}/${default_fps%.*}))
    speedup_track=$((speedup_track + speedup))
    runs=$((runs+1))
  done
    echo -e "\n"
done

echo "#############################################"
echo "Average Intel Optimized speedup = $(($speedup_track / $runs))X" 
echo "#############################################"
echo $'\n\n'

