# !/bin/bash
# Usage: bash intel_tf_cnn_benchmarks <option> 
# 
# By default, this runs only InceptionV3 at batch size 64. Pass "all" in the <option> 
# position to run all networks and batch sizes in the benchmarking suite.
# 
# This script runs TensorFlow's CNN Benchmarks and summarizes throughput increases when  
# using Intel optimized TensorFlow.
# Note: you may need to edit benchmarks/scripts/tf_cnn_benchmarks/datasets.py to import _pickle instead of Cpickle


# Check if "all" option was passed, set networks and batch sizes accordingly
option=$1
if [ -z $option ]
then
  networks=( inception3 )
  batch_sizes=( 64 )
else
  networks=( inception3 resnet50 resnet152 vgg16 )
  batch_sizes=( 32 64 96 128 )
fi

# Clone benchmark scripts
git clone -b mkl_experiment https://github.com/tensorflow/benchmarks.git
cd benchmarks/scripts/tf_cnn_benchmarks
rm *.log # remove logs from any previous benchmark runs

## Run benchmark scripts in the default environment
for network in "${networks[@]}" ; do
  for bs in "${batch_sizes[@]}"; do
    echo -e "\n\n #### Starting $network and batch size = $bs ####\n\n"

    time python tf_cnn_benchmarks.py --data_format NHWC --data_name synthetic --model "$network" --forward_only False -batch_size "$bs" --num_batches 50 2>&1 | tee net_"$network"_bs_"$bs"_default.log

  done
done

## Run benchmark scripts in the Intel Optimized environment
source activate intel_tensorflow_p36

for network in "${networks[@]}" ; do
  for bs in "${batch_sizes[@]}"; do
    echo -e "\n\n #### Starting $network and batch size = $bs ####\n\n"

    time python tf_cnn_benchmarks.py --data_format NCHW --data_name synthetic --model "$network" --forward_only False -batch_size "$bs" --num_batches 10 2>&1 | tee net_"$network"_bs_"$bs"_optimized.log

  done
done

source deactivate

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
    default_fps="10.2" #$(grep  "total images/sec:"  net_"$network"_bs_"$bs"_default.log | cut -d ":" -f2 | xargs)
    optimized_fps=$(grep  "total images/sec:"  net_"$network"_bs_"$bs"_optimized.log | cut -d ":" -f2 | xargs)
    echo "Default     | $network |    $bs    | $default_fps"
    echo "Optimized   | $network |    $bs    | $optimized_fps"
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

