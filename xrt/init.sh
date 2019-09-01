#!/bin/sh

# init
python build/install-build-deps.sh

# use_sysroot
python build/linux/sysroot_scripts/install-sysroot.py --arch=x64

# use_custom_libcxx

