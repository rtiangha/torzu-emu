// SPDX-FileCopyrightText: Copyright 2018 torzu Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#pragma once

namespace DebuggerTorzu {

/**
 * Uses the WINAPI to hide or show the stderr console. This function is a placeholder until we can
 * get a real qt logging window which would work for all platforms.
 */
void ToggleConsole();
} // namespace DebuggerTorzu
