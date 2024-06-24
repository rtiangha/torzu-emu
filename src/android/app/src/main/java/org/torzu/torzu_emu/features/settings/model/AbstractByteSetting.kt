// SPDX-FileCopyrightText: 2023 torzu Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

package org.torzu.torzu_emu.features.settings.model

interface AbstractByteSetting : AbstractSetting {
    fun getByte(needsGlobal: Boolean = false): Byte
    fun setByte(value: Byte)
}
