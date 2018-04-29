#!/bin/bash

SUPPORTED_ARCHITECTURES=(x86 armeabi-v7a)
# SUPPORTED_ARCHITECTURES=(armeabi-v7a arm64-v8a x86)
ANDROID_NDK_ROOT_PATH=${ANDROID_NDK}
if [[ -z "$ANDROID_NDK_ROOT_PATH" ]]; then
  echo "You need to set ANDROID_NDK environment variable, please check instructions"
  exit
fi

NUMBER_OF_CORES=4
HOST_UNAME=$(uname -m)
TARGET_OS=android

CFLAGS='-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -fno-strict-overflow -fstack-protector-all'
LDFLAGS='-Wl,-z,relro -Wl,-z,now -pie'

FFMPEG_PKG_CONFIG="$(pwd)/ffmpeg-pkg-config"
