#!/bin/bash -ex

if [ "$TARGET" = "appimage" ]; then
    # Compile the AppImage we distribute with Clang.
    export EXTRA_CMAKE_FLAGS=(-DCMAKE_LINKER=/usr/bin/lld-17)
    # Bundle required QT wayland libraries
    export EXTRA_QT_PLUGINS="waylandcompositor"
    export EXTRA_PLATFORM_PLUGINS="libqwayland-egl.so;libqwayland-generic.so"
else
    # For the linux-fresh verification target, verify compilation without PCH as well.
    export EXTRA_CMAKE_FLAGS=(-DTORZU_USE_PRECOMPILED_HEADERS=OFF)
fi

mkdir build && cd build
cmake .. -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DCMAKE_CXX_COMPILER=clang++-17 \
    -DCMAKE_C_COMPILER=clang-17 \
    -DCMAKE_CXX_FLAGS="-O2" \
    -DCMAKE_C_FLAGS="-O2" \
    "${EXTRA_CMAKE_FLAGS[@]}" \
    -DTORZU_ENABLE_LTO=ON \
    -DTORZU_USE_BUNDLED_VCPKG=ON \
    -DTORZU_USE_BUNDLED_FFMPEG=OFF \
    -DTORZU_TESTS=OFF \
    -DTORZU_ENABLE_LTO=OFF \
    -DTORZU_USE_EXTERNAL_SDL2=ON \
    -DDTORZU_USE_QT_WEB_ENGINE=ON \
    -DUSE_DISCORD_PRESENCE=ON \
    -DENABLE_QT6=ON \
    -DENABLE_WEB_SERVICE=OFF

ninja
strip -s bin/torzu
strip -s bin/torzu-cmd
strip -s bin/torzu-room

if [ "$TARGET" = "appimage" ]; then
    ninja bundle
    # TODO: Our AppImage environment currently uses an older ccache version without the verbose flag.
    ccache -s
else
    ccache -s -v
fi

ctest -VV -C Release
