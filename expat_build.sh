#!/bin/bash

. abi_settings.sh $1 $2 $3

# pushd expat-2.1.0
pushd libexpat/expat

./buildconf.sh

# with-docbook required to make dist, so
# brew install docbook2x

make clean

./configure \
  --with-pic \
  --with-docbook \
  --with-sysroot="$NDK_SYSROOT" \
  --host="$NDK_TOOLCHAIN_ABI" \
  --enable-static \
  --disable-shared \
  --prefix="${TOOLCHAIN_PREFIX}" || exit 1

make -j${NUMBER_OF_CORES} install || exit 1
