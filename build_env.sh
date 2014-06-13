#!/bin/sh

PACKAGES="python-pip python-dev g++-4.6 gfortran protobuf-compiler libprotobuf-dev libatlas-base-dev libleveldb-dev libsnappy-dev libopencv-dev libboost-all-dev libhdf5-serial-dev libgoogle-glog-dev"

dpkg -L $PACKAGES > /dev/null
if [ "$?" != "0" ]
then
	sudo apt-get update
	sudo apt-get install $PACKAGES
fi

if [ ! -d /usr/local/cuda ]
then
    wget http://developer.download.nvidia.com/compute/cuda/6_0/rel/installers/cuda_6.0.37_linux_64.run -O /tmp/cuda.run
    chmod 755 /tmp/cuda.run
    sudo /tmp/cuda.run -silent -toolkit -override
    echo "/usr/local/cuda/lib64" > /tmp/cuda.conf
    sudo mv /tmp/cuda.conf /etc/ld.so.conf.d
    sudo ldconfig
fi

sudo pip install -r caffe/python/requirements.txt

