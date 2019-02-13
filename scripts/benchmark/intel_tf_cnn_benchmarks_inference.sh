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

# Run TensorFlow's tf_cnn benchmarks with various networks and batchsizes with MKL.
# Assumption is TF w/ MKL is installed.

#Set benchmark parameters.
num_warmup_batches=20
num_batches=30
num_inter_threads=2
kmp_blocktime=0

#networks=( alexnet googlenet inception3 resnet50 resnet152 vgg16 )
networks=( inception3 resnet50 resnet152 vgg16 )
batch_sizes=( 1 16 32 64 128 )

# Assign num_cores to the number of physical cores on your machine
cores_per_socket=`lscpu | grep "Core(s) per socket" | cut -d':' -f2 | xargs`
num_sockets=`lscpu | grep "Socket(s)" | cut -d':' -f2 | xargs`
num_cores=$((cores_per_socket * num_sockets))

if [ -d benchmarks ]
then
    echo -e "tf_cnn_bechmarks repo exists. Will use the existing repo \n"
else
    git clone https://github.com/tensorflow/benchmarks.git
    echo -e "Downloaded tf_cnn_bechmarks repo. \n"
fi

cd benchmarks/scripts/tf_cnn_benchmarks/

date > start_bench_dummydata_inf_mkl.txt

start=$(date +'%s')
for network in "${networks[@]}" ; do
  for bs in "${batch_sizes[@]}"; do
        sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
        echo -e "\n\n #### Starting Inference with DummyData: $network ,BS = $bs ####\n\n"

        time python tf_cnn_benchmarks.py --device=cpu --mkl=True --data_format=NCHW \
              --kmp_affinity='granularity=fine,noverbose,compact,1,0' \
              --kmp_blocktime=$kmp_blocktime --kmp_settings=1 \
              --num_warmup_batches=$num_warmup_batches --batch_size=$bs \
              --num_batches=$num_batches --model=$network  \
              --num_intra_threads=$num_cores --num_inter_threads=$num_inter_threads \
              --forward_only=True \
              2>&1 | tee mkl_inf_numcores_${num_cores}_net_${network}_bs_${bs}.log

        echo -e "#### Finished MKL Inference w/DummyData: $network with BS=$bs ####"
  done
done
echo -e "\n\n ## MKL Inference w/DummyData script took $(($(date +'%s') - $start)) seconds \n"
date > stop_bench_dummydata_inf_mkl.txt

## Print benchmark throughput

echo -e "\nNetwork batch_size images/second (Inference) \n"

for network in "${networks[@]}" ; do
  for bs in "${batch_sizes[@]}"; do
    fps=$(grep  "total images/sec:"  mkl_inf_numcores_${num_cores}_net_${network}_bs_${bs}.log | cut -d ":" -f2 | xargs)
    echo "$network $bs $fps"
  done
    echo -e "\n"
done
