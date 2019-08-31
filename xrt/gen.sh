#!/bin/sh

gn --root=src args out/linux/debug --args="is_clang=false is_component_build=false use_sysroot=false use_custom_libcxx=false symbol_level=0"
