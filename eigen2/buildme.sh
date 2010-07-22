#!/bin/bash

PREFIX=`pwd`
if [ ! -z $1 ]; then
    if [ foo`echo $1 | sed 's:\(.\).*:\1:'` = "foo/" ]; then
        PREFIX=$1
    else
        PREFIX=`pwd`/$1
    fi
fi

if [ -e eigen-2.0.15 ]; then
    echo "looks like you already have eigen-2.0.15"
    echo "move it out of the way before running this script"
    exit 42
fi

echo "extracting eigen2 tarball"
tar xfj eigen-2.0.15.tar.bz2
if [ $? -ne 0 ]; then
    echo "ERROR tar xfj eigen-2.0.15.tar.bz2"
    exit 42
fi

echo "configuring eigen2 sources"
cd eigen-2.0.15
if [ $? -ne 0 ]; then
    echo "ERROR cd eigen-2.0.15"
    exit 42
fi
cmake . -DCMAKE_INSTALL_PREFIX=$PREFIX
if [ $? -ne 0 ]; then
    echo "ERROR cmake . -DCMAKE_INSTALL_PREFIX=$PREFIX"
    cd ..
    exit 42
fi

echo "building eigen"
make
if [ $? -ne 0 ]; then
    echo "ERROR make"
    cd ..
    exit 42
fi

echo "installing eigen2"
make install
if [ $? -ne 0 ]; then
    echo "ERROR make install, trying with sudo..."
    sudo make install
    if [ $? -ne 0 ]; then
	echo 'nah, that did not work either'
    fi
    cd ..
    exit 42
fi

echo "looks good, you should have eigen2 now"
