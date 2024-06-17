#!/bin/sh -ex

mkdir build && cd build

cmake .. -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DYUZU_USE_BUNDLED_VCPKG=OFF \
    -DYUZU_TESTS=OFF \
    -DYUZU_ENABLE_LTO=ON \
    -DYUZU_USE_EXTERNAL_VULKAN_HEADERS=OFF \
    -DYUZU_USE_EXTERNAL_VULKAN_SPIRV_TOOLS=OFF \
    -DYUZU_USE_EXTERNAL_VULKAN_UTILITY_LIBRARIES=OFF \
    -DYUZU_USE_BUNDLED_FFMPEG=OFF \
    -DUSE_DISCORD_PRESENCE=ON \
    -DENABLE_QT6=OFF \
    -DENABLE_LIBUSB=ON \
    -DENABLE_WEB_SERVICE=OFF 

ninja
ninja bundle
strip -s bundle/*.exe

ccache -s -v

ctest -VV -C Release || echo "::error ::Test error occurred on Windows build"
