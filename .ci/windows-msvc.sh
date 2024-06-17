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
    -DYUZU_USE_BUNDLED_SDL2=OFF \
    -DUSE_DISCORD_PRESENCE=ON \
    -DYUZU_USE_QT_WEB_ENGINE=ON \
    -DUSE_SYSTEM_ZSTD=OFF \
    -DENABLE_WEB_SERVICE=OFF

ninja
ninja bundle

ccache -s -v

ctest -VV -C Release || echo "::error ::Test error occurred on Windows build"
