## Benchmarking

This repo contains benchmarking scripts for training and inference on common CNN topologies in TensorFlow: 

* Inception V3
* ResNet 50
* ResNet 152
* VGG 16

To initiate benchmarking, cd into this directory and run `bash intel_tf_cnn_benchmarks.sh` for training or `bash intel_tf_cnn_benchmarks_inference.sh` for inference. This will execute the Inception V3 model with BS=128 for training or BS=1 for inference. To run all topologies, pass `all` as an argument to the script: `bash intel_tf_cnn_benchmarks.sh all`

Each script takes the following actions:

1. Detects which version of TensorFlow is present and clones the official TensorFlow benchmarks repo.
2. Runs the tf_cnn_benchmarks.py in the default environment.
3. Activates the optimized virtualenv and runs the tf_cnn_benchmarks.py in the Intel Optimized environment.
4. Prints the throughput or latency values (for training or inference, respectively) with relative speedups realized with Intel Optimized TensorFlow.

Running the entire benchmarking suite may take some time depending on the hardware you're running on, so please be patient while it is executing.
