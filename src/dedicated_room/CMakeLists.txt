# SPDX-FileCopyrightText: 2017 Citra Emulator Project
# SPDX-License-Identifier: GPL-2.0-or-later

add_executable(torzu-room
    precompiled_headers.h
    torzu_room.cpp
    torzu_room.rc
)

target_link_libraries(torzu-room PRIVATE common network)
if (ENABLE_WEB_SERVICE)
    target_compile_definitions(torzu-room PRIVATE -DENABLE_WEB_SERVICE)
    target_link_libraries(torzu-room PRIVATE web_service)
endif()

target_link_libraries(torzu-room PRIVATE mbedtls mbedcrypto)
if (MSVC)
    target_link_libraries(torzu-room PRIVATE getopt)
endif()
target_link_libraries(torzu-room PRIVATE ${PLATFORM_LIBRARIES} Threads::Threads)

if(UNIX AND NOT APPLE)
    install(TARGETS torzu-room)
endif()

if (TORZU_USE_PRECOMPILED_HEADERS)
    target_precompile_headers(torzu-room PRIVATE precompiled_headers.h)
endif()

# Bundle in-place on MSVC so dependencies can be resolved by builds.
if (MSVC)
    include(BundleTarget)
    bundle_target_in_place(torzu-room)
endif()

create_target_directory_groups(torzu-room)
