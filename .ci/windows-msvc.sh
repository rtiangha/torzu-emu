#!/bin/sh -ex

mkdir build && cd build

cmake .. -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DYUZU_USE_BUNDLED_VCPKG=OFF \
    -DYUZU_TESTS=OFF \
    -DYUZU_ENABLE_LTO=ON \
    -DYUZU_USE_BUNDLED_QT=OFF \
    -DUSE_DISCORD_PRESENCE=ON \
    -DENABLE_WEB_SERVICE=OFF

ninja
ninja bundle

ccache -s -v

ctest -VV -C Release || echo "::error ::Test error occurred on Windows build"
