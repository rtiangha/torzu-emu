#!/bin/bash -ex

if [ "$TARGET" = "appimage" ]; then
    # Compile the AppImage we distribute with Clang.
    export EXTRA_CMAKE_FLAGS=(-DCMAKE_LINKER=/usr/bin/lld-18)
    # Bundle required QT wayland libraries
    export EXTRA_QT_PLUGINS="waylandcompositor"
    export EXTRA_PLATFORM_PLUGINS="libqwayland-egl.so;libqwayland-generic.so"
else
    # For the linux-fresh verification target, verify compilation without PCH as well.
    export EXTRA_CMAKE_FLAGS=(-DTORZU_USE_PRECOMPILED_HEADERS=OFF)
fi

cd build

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
