// SPDX-FileCopyrightText: 2024 torzu Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

package org.torzu.torzu_emu.model

enum class GameVerificationResult(val int: Int) {
    Success(0),
    Failed(1),
    NotImplemented(2);

    companion object {
        fun from(int: Int): GameVerificationResult =
            entries.firstOrNull { it.int == int } ?: Success
    }
}
