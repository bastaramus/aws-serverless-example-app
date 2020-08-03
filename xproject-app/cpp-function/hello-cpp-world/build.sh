#!/bin/bash
set -eo pipefail
rm -rf /root/hello-cpp-world/build
mkdir /root/hello-cpp-world/build
cd hello-cpp-world/build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/root/install
make
make aws-lambda-package-hello