#!/bin/bash -ex

if [ "$TARGET" = "appimage" ]; then
    # Compile the AppImage we distribute with Clang.
    export EXTRA_CMAKE_FLAGS=(-DCMAKE_LINKER=/etc/bin/ld.lld)
else
    # For the linux-fresh verification target, verify compilation without PCH as well.
    export EXTRA_CMAKE_FLAGS=(-DYUZU_USE_PRECOMPILED_HEADERS=OFF)
fi

mkdir build && cd build
cmake .. -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DCMAKE_CXX_COMPILER=clang++-17 \
    -DCMAKE_C_COMPILER=clang-17 \
    "${EXTRA_CMAKE_FLAGS[@]}" \
    -DYUZU_ENABLE_LTO=ON \
    -DYUZU_USE_BUNDLED_VCPKG=ON \
    -DYUZU_USE_BUNDLED_FFMPEG=OFF \
    -DYUZU_TESTS=OFF \
    -DYUZU_ENABLE_LTO=OFF \
    -DYUZU_USE_EXTERNAL_SDL2=ON \
    -DDYUZU_USE_QT_WEB_ENGINE=ON \
    -DUSE_DISCORD_PRESENCE=ON \
    -DENABLE_QT6=OFF \
    -DENABLE_WEB_SERVICE=OFF

ninja
strip -s bin/yuzu
strip -s bin/yuzu-cmd
strip -s bin/yuzu-room

if [ "$TARGET" = "appimage" ]; then
    ninja bundle
    # TODO: Our AppImage environment currently uses an older ccache version without the verbose flag.
    ccache -s
else
    ccache -s -v
fi

ctest -VV -C Release
