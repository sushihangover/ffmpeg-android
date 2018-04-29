#!/bin/bash

. settings.sh

# https://developer.android.com/ndk/guides/standalone_toolchain.html

BASEDIR=$2

export ANDROID_API_VERSION=21

# stdin/stdout/stderr
# Adding the api explicitly to the gcc build does work:
# CFLAGS=-D__ANDROID_API__=14 LDFLAGS=-D__ANDROID_API__=14 CXXFLAGS=-D__ANDROID_API__=14

case $1 in
  arm64-v8a)
    NDK_ABI="arm64"
    export ANDROID_API_VERSION=21
    NDK_TOOLCHAIN_ABI=aarch64-linux-android
    NDK_CROSS_PREFIX=${NDK_TOOLCHAIN_ABI}
    CFLAGS="$CFLAGS -fPIE"
    LDFLAGS="-fPIE -pie -lm -lz -Wl,--no-undefined -Wl,-z,noexecstack"
  ;;
  armeabi-v7a)
    NDK_ABI="arm"
    NDK_TOOLCHAIN_ABI='arm-linux-androideabi'
    NDK_CROSS_PREFIX="${NDK_TOOLCHAIN_ABI}"
    CFLAGS="$CFLAGS -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=softfp -fPIE"
    LDFLAGS="-fPIE -pie -lm -lz -Wl,--no-undefined -Wl,-z,noexecstack"
  ;;
  x86)
    NDK_ABI="x86"
    NDK_TOOLCHAIN_ABI='x86'
    NDK_CROSS_PREFIX="i686-linux-android"
    CFLAGS="$CFLAGS -fPIE -pie -std=c99 -O3 -Wall -pipe -DANDROID -DNDEBUG -march=atom -msse3 -ffast-math -mfpmath=sse"
    LDFLAGS="-fPIE -pie -lm -lz -Wl,--no-undefined -Wl,-z,noexecstack"
  ;;
esac

TOOLCHAIN_PREFIX=${BASEDIR}/toolchain-android
if [ ! -d "$TOOLCHAIN_PREFIX" ]; then
  ${ANDROID_NDK_ROOT_PATH}/build/tools/make_standalone_toolchain.py --api=${ANDROID_API_VERSION} --arch=${NDK_ABI} --install-dir=${TOOLCHAIN_PREFIX}
fi
CROSS_PREFIX=${TOOLCHAIN_PREFIX}/bin/${NDK_CROSS_PREFIX}-

NDK_SYSROOT=${TOOLCHAIN_PREFIX}/sysroot
# NDK_SYSROOT=/Users/Sushi/AndroidSDKs/android-sdk-macosx/ndk-bundle/sysroot

export PKG_CONFIG_LIBDIR="${TOOLCHAIN_PREFIX}/lib/pkgconfig"

if [ $3 == 1 ]; then
  #export CC="${CROSS_PREFIX}clang --sysroot=${NDK_SYSROOT}"
  export CC="${CROSS_PREFIX}clang"
  export LD="${CROSS_PREFIX}ld"
  export RANLIB="${CROSS_PREFIX}ranlib"
  export STRIP="${CROSS_PREFIX}strip"
  export READELF="${CROSS_PREFIX}readelf"
  export OBJDUMP="${CROSS_PREFIX}objdump"
  export ADDR2LINE="${CROSS_PREFIX}addr2line"
  export AR="${CROSS_PREFIX}ar"
  export AS="${CROSS_PREFIX}clang"
  # export CXX="${CROSS_PREFIX}clang++"
  export CXX="${CROSS_PREFIX}clang++"
  export OBJCOPY="${CROSS_PREFIX}objcopy"
  export ELFEDIT="${CROSS_PREFIX}elfedit"
#  export CPP="clang"
  export DWP="${CROSS_PREFIX}dwp"
  export GCONV="${CROSS_PREFIX}gconv"
  export GDP="${CROSS_PREFIX}gdb"
  export GPROF="${CROSS_PREFIX}gprof"
  export NM="${CROSS_PREFIX}nm"
  export SIZE="${CROSS_PREFIX}size"
  export STRINGS="${CROSS_PREFIX}strings"
fi

