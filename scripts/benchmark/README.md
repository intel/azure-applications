## Benchmarking

This repo contains benchmarking scripts for training and inference on common CNN topologies in TensorFlow: 

* Inception V3
* ResNet 50
* ResNet 152
* VGG 16

#### Steps to run training benchmark:
```
wget https://raw.githubusercontent.com/IntelAI/azure-applications/master/scripts/benchmark/intel_tf_cnn_benchmarks.sh
bash intel_tf_cnn_benchmarks.sh
```

This will execute the Inception V3 model with BS=128 for training. To run all topologies, pass `all` as an argument to the script: `bash intel_tf_cnn_benchmarks.sh all`

#### Steps to run inference benchmark:
```
wget https://raw.githubusercontent.com/IntelAI/azure-applications/master/scripts/benchmark/intel_tf_cnn_benchmarks_inference.sh
bash intel_tf_cnn_benchmarks_inference.sh
```
This will execute the Inception V3 model with BS=1 for inference. To run all topologies, pass `all` as an argument to the script: `bash intel_tf_cnn_benchmarks_inference.sh all`


Each script takes the following actions:

1. Detects which version of TensorFlow is present and clones the official TensorFlow benchmarks repo.
2. Runs `tf_cnn_benchmarks.py` in the default environment.
3. Activates the optimized virtualenv and runs `tf_cnn_benchmarks.py` in the Intel Optimized environment.
4. Prints the throughput or latency values (for training or inference, respectively) with relative speedups realized with Intel Optimized TensorFlow.

**NOTE:** Running the entire benchmarking suite may take some time depending on the hardware you're running on, so please be patient while it is executing.
