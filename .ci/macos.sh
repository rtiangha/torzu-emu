#!/bin/bash -ex

mkdir build && cd build
cmake .. -GNinja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_OSX_ARCHITECTURES="$TARGET" \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DCMAKE_CXX_FLAGS="-O2" \
    -DCMAKE_C_FLAGS="-O2" \
    -DTORZU_ENABLE_LTO=ON \
    -DTORZU_USE_BUNDLED_VCPKG=OFF \
    -DTORZU_USE_QT_WEB_ENGINE=ON \
    -DTORZU_TESTS=OFF \
    -DENABLE_WEB_SERVICE=OFF \
    -DENABLE_LIBUSB=OFF \
    -DENABLE_QT6=ON \
    -DUSE_DISCORD_PRESENCE=ON
ninja
ninja bundle

ccache -s -v

CURRENT_ARCH=`arch`
if [ "$TARGET" = "$CURRENT_ARCH" ]; then
  ctest -VV -C Release
fi
