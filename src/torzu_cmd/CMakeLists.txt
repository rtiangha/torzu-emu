# SPDX-FileCopyrightText: 2018 torzu Emulator Project
# SPDX-License-Identifier: GPL-2.0-or-later

# Credits to Samantas5855 and others for this function.
function(create_resource file output filename)
    # Read hex data from file
    file(READ ${file} filedata HEX)
    # Convert hex data for C compatibility
    string(REGEX REPLACE "([0-9a-f][0-9a-f])" "0x\\1," filedata ${filedata})
    # Write data to output file
    set(RESOURCES_DIR "${PROJECT_BINARY_DIR}/dist" PARENT_SCOPE)
    file(WRITE "${PROJECT_BINARY_DIR}/dist/${output}" "const unsigned char ${filename}[] = {${filedata}};\nconst unsigned ${filename}_size = sizeof(${filename});\n")
endfunction()

if (TORZU_CMD)
    add_executable(torzu-cmd
        emu_window/emu_window_sdl2.cpp
        emu_window/emu_window_sdl2.h
        emu_window/emu_window_sdl2_gl.cpp
        emu_window/emu_window_sdl2_gl.h
        emu_window/emu_window_sdl2_null.cpp
        emu_window/emu_window_sdl2_null.h
        emu_window/emu_window_sdl2_vk.cpp
        emu_window/emu_window_sdl2_vk.h
        precompiled_headers.h
        sdl_config.cpp
        sdl_config.h
        torzu.cpp
        torzu.rc
    )

    target_link_libraries(torzu-cmd PRIVATE common core input_common frontend_common)
    target_link_libraries(torzu-cmd PRIVATE glad)
    if (MSVC)
        target_link_libraries(torzu-cmd PRIVATE getopt)
    endif()
    target_link_libraries(torzu-cmd PRIVATE ${PLATFORM_LIBRARIES} Threads::Threads)

    create_resource("../../dist/torzu.bmp" "torzu_cmd/torzu_icon.h" "torzu_icon")
    target_include_directories(torzu-cmd PRIVATE ${RESOURCES_DIR})

    target_link_libraries(torzu-cmd PRIVATE SDL2::SDL2 Vulkan::Headers)

    if(UNIX AND NOT APPLE)
        install(TARGETS torzu-cmd)
    endif()

    if(WIN32)
        # compile as a win32 gui application instead of a console application
        if(MSVC)
            set_target_properties(torzu-cmd PROPERTIES LINK_FLAGS_RELEASE "/SUBSYSTEM:WINDOWS /ENTRY:mainCRTStartup")
        elseif(MINGW)
            set_target_properties(torzu-cmd PROPERTIES LINK_FLAGS_RELEASE "-Wl,--subsystem,windows")
        endif()
    endif()

    if (MSVC)
        include(CopyTorzuSDLDeps)
        copy_torzu_SDL_deps(torzu-cmd)
    endif()

    if (TORZU_USE_PRECOMPILED_HEADERS)
        target_precompile_headers(torzu-cmd PRIVATE precompiled_headers.h)
    endif()

    create_target_directory_groups(torzu-cmd)
endif()
