FROM amazonlinux:2017.03

RUN yum install wget gcc64-c++ git make curl-devel libcurl-devel openssl-devel gtest-devel python36-pip zlib-devel zip -y

RUN pip-3.6 install --upgrade pip

WORKDIR /root

#Install cmake3
RUN wget https://cmake.org/files/v3.13/cmake-3.13.0.tar.gz && \
    tar -xvzf cmake-3.13.0.tar.gz && \
    cd cmake-3.13.0 && \
    ./bootstrap && \
    make && \
    make install

RUN mkdir /root/install

#Build the AWS C++ SDK
RUN git clone https://github.com/aws/aws-sdk-cpp.git && \
    cd aws-sdk-cpp && \
    mkdir build && \
    cd build && \
    cmake .. -DBUILD_ONLY="core" \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=OFF \
        -DENABLE_UNITY_BUILD=ON \
        -DCUSTOM_MEMORY_MANAGEMENT=OFF \
        -DCMAKE_INSTALL_PREFIX=/root/install \
        -DENABLE_UNITY_BUILD=ON && \
    make && \
    make install

#Build the Runtime
RUN git clone https://github.com/awslabs/aws-lambda-cpp.git && \
    cd aws-lambda-cpp && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=OFF \
        -DCMAKE_INSTALL_PREFIX=/root/install && \
    make && \
    make install

#Clean
RUN rm -rf aws-sdk-cpp && \
    rm -rf cmake-3.13.0.tar.gz && \
    rm -rf cmake-3.13.0 && \
    rm -rf aws-lambda-cpp && \
    yum clean all && \
    rm -rf /var/cache/yum