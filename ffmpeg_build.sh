#!/bin/bash

. abi_settings.sh $1 $2 $3

pushd ffmpeg

TARGET_OS=android

case $1 in
  arm64-v8a)
    CPU='ARMv8'
    NDK_ABI='aarch64'
    EXTRACFLAGS="-O3 -DANDROID -Dipv6mr_interface=ipv6mr_ifindex -fasm -Wno-psabi -fno-short-enums -fno-strict-aliasing"
    TARGET_OS=linux
  ;;
  armeabi-v7a | armeabi-v7a-neon)
    CPU='cortex-a8'
    CONFIG='--cpu='${CPU}
  ;;
  x86)
    CPU='i686'
    CONFIG='--cpu='${CPU}
  ;;
esac

make clean

CFLAGS="$CFLAGS -D__ANDROID_API__=$ANDROID_API_VERSION"
# LDFLAGS="-fPIE -pie"

# CFLAGS=""
# LDFLAGS=""

echo ${CPU}
echo ${NDK_ABI}
echo ${CROSS_PREFIX}
echo ${TARGET_OS}
echo ${CFLAGS}
echo ${LDFLAGS}
echo ${CXX_FLAGS}
echo ${NDK_SYSROOT}
echo ${CONFIG}
echo "@@@@@@@@@"

echo ${FFMPEG_PKG_CONFIG}

# --enable-libass \
# --enable-libfreetype \
# --enable-libfribidi \
# --enable-libmp3lame \
# --enable-fontconfig \
# --enable-libx264 \

# --cross-prefix="$CROSS_PREFIX" \

# NDK_SYSROOT=${TOOLCHAIN_PREFIX}/sysroot
# NDK_SYSROOT=/Users/Sushi/AndroidSDKs/android-sdk-macosx/ndk-bundle/sysroot

# undefined reference to 'stdout'
# --disable-shared \
# --enable-static \
# --pkg-config="../ffmpeg-pkg-config" \
# --enable-asm

# export PKG_CONFIG_PATH=${TOOLCHAIN_PREFIX}/lib/pkgconfig

#--cpu="$CPU" \

./configure \
--prefix="${2}/build/${1}" \
--target-os="$TARGET_OS" \
--arch="$NDK_ABI" ${CONFIG} \
--cross-prefix="$CROSS_PREFIX" \
--enable-cross-compile \
--enable-runtime-cpudetect \
--sysroot="$NDK_SYSROOT" \
--disable-symver \
--enable-pic \
--enable-pthreads \
--enable-libass \
--enable-libfreetype \
--enable-libfribidi \
--enable-libmp3lame \
--enable-fontconfig \
--enable-libx264 \
--disable-debug \
--enable-version3 \
--enable-hardcoded-tables \
--enable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--enable-gpl \
--disable-asm \
--disable-x86asm \
--disable-doc \
--disable-shared \
--enable-static \
--pkg-config=pkg-config \
--extra-libs="-lpng -lexpat -lm" \
--extra-cflags="-I${TOOLCHAIN_PREFIX}/include $CFLAGS $EXTRACFLAGS" \
--extra-ldflags="-L${TOOLCHAIN_PREFIX}/lib $LDFLAGS" \
--extra-cxxflags="$CXX_FLAGS" || exit 1

# --extra-libs="-lpng -lexpat -lm" \
# --pkg-config="${2}/ffmpeg-pkg-config" \

make -j${NUMBER_OF_CORES} && make install || exit 1

popd

