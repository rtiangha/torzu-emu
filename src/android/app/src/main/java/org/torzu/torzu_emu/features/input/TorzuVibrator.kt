// SPDX-FileCopyrightText: 2024 torzu Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

package org.torzu.torzu_emu.features.input

import android.content.Context
import android.os.Build
import android.os.CombinedVibration
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.view.InputDevice
import androidx.annotation.Keep
import androidx.annotation.RequiresApi
import org.torzu.torzu_emu.TorzuApplication

@Keep
@Suppress("DEPRECATION")
interface TorzuVibrator {
    fun supportsVibration(): Boolean

    fun vibrate(intensity: Float)

    companion object {
        fun getControllerVibrator(device: InputDevice): TorzuVibrator =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                TorzuVibratorManager(device.vibratorManager)
            } else {
                TorzuVibratorManagerCompat(device.vibrator)
            }

        fun getSystemVibrator(): TorzuVibrator =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vibratorManager = TorzuApplication.appContext
                    .getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
                TorzuVibratorManager(vibratorManager)
            } else {
                val vibrator = TorzuApplication.appContext
                    .getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
                TorzuVibratorManagerCompat(vibrator)
            }

        fun getVibrationEffect(intensity: Float): VibrationEffect? {
            if (intensity > 0f) {
                return VibrationEffect.createOneShot(
                    50,
                    (255.0 * intensity).toInt().coerceIn(1, 255)
                )
            }
            return null
        }
    }
}

@RequiresApi(Build.VERSION_CODES.S)
class TorzuVibratorManager(private val vibratorManager: VibratorManager) : TorzuVibrator {
    override fun supportsVibration(): Boolean {
        return vibratorManager.vibratorIds.isNotEmpty()
    }

    override fun vibrate(intensity: Float) {
        val vibration = TorzuVibrator.getVibrationEffect(intensity) ?: return
        vibratorManager.vibrate(CombinedVibration.createParallel(vibration))
    }
}

class TorzuVibratorManagerCompat(private val vibrator: Vibrator) : TorzuVibrator {
    override fun supportsVibration(): Boolean {
        return vibrator.hasVibrator()
    }

    override fun vibrate(intensity: Float) {
        val vibration = TorzuVibrator.getVibrationEffect(intensity) ?: return
        vibrator.vibrate(vibration)
    }
}
