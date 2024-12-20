#!/bin/bash -ex

# SPDX-FileCopyrightText: 2023 torzu Emulator Project
# SPDX-License-Identifier: GPL-3.0-or-later

export NDK_CCACHE="$(which ccache)"
ccache -s

BUILD_FLAVOR="mainline"

BUILD_TYPE="release"
if [ "${GITHUB_REPOSITORY}" == "torzu-emu/torzu" ]; then
    BUILD_TYPE="relWithDebInfo"
fi

if [ ! -z "${ANDROID_KEYSTORE_B64}" ]; then
    export ANDROID_KEYSTORE_FILE="${GITHUB_WORKSPACE}/ks.jks"
    base64 --decode <<< "${ANDROID_KEYSTORE_B64}" > "${ANDROID_KEYSTORE_FILE}"
fi

# Build Vulkan-ValidationLayers
mkdir -p src/android/app/build/tmp
mkdir -p assets/libs/lib/arm64-v8a

cd externals/Vulkan-ValidationLayers

# Build vvl release binary for arm64-v8a
cmake -S . -B build \
  -D CMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake \
  -D CMAKE_C_COMPILER_LAUNCHER=ccache \
  -D CMAKE_CXX_COMPILER_LAUNCHER=ccache \
  -D CMAKE_CXX_COMPILER=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android30-clang++ \
  -D CMAKE_C_COMPILER=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android30-clang \
  -D CMAKE_CXX_FLAGS="-O2" \
  -D CMAKE_C_FLAGS="-O2" \
  -D CMAKE_EXE_LINKER_FLAGS=-flto=thin \
  -D CMAKE_SHARED_LINKER_FLAGS=-flto=thin \
  -D ANDROID_PLATFORM=30 \
  -D CMAKE_ANDROID_ARCH_ABI=arm64-v8a \
  -D CMAKE_ANDROID_STL_TYPE=c++_static \
  -D ANDROID_USE_LEGACY_TOOLCHAIN_FILE=NO \
  -D CMAKE_BUILD_TYPE=Release \
  -D UPDATE_DEPS=ON \
  -G Ninja

cd build
ninja
cd ..

cmake --install build --prefix build/libs/arm64-v8a
mv build/libs/arm64-v8a/lib/libVkLayer_khronos_validation.so ../../assets/libs/lib/arm64-v8a

cd ../../assets/libs
zip -r vvl-android.zip lib
mv vvl-android.zip ../../externals
cd ../..


# Build torzu
cd src/android
chmod +x ./gradlew
./gradlew "assemble${BUILD_FLAVOR}${BUILD_TYPE}" "bundle${BUILD_FLAVOR}${BUILD_TYPE}"

ccache -s

if [ ! -z "${ANDROID_KEYSTORE_B64}" ]; then
    rm "${ANDROID_KEYSTORE_FILE}"
fi
