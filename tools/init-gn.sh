#!/bin/bash

set -e
set -v

# build gn
git clone https://gn.googlesource.com/gn

cd gn
python build/gen.py
ninja -C out
# To run tests:
out/gn_unittests