#!/bin/bash

set -e
set -v

mkdir gn_standalone
cd gn_standalone
mkdir -p third_party/libevent
cd third_party/libevent
wget --no-check-certificate https://chromium.googlesource.com/chromium/chromium/+archive/master/third_party/libevent.tar.gz
tar -xvzf libevent.tar.gz
cd ../..
git clone https://chromium.googlesource.com/chromium/src/base
git clone https://chromium.googlesource.com/chromium/src/build
git clone https://chromium.googlesource.com/chromium/src/build/config
mkdir testing
cd testing
git clone https://chromium.googlesource.com/chromium/testing
cd ..