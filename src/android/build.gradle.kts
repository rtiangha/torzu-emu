// SPDX-FileCopyrightText: 2023 torzu Emulator Project
// SPDX-License-Identifier: GPL-3.0-or-later

// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    id("com.android.application") version "8.7.1" apply false
    id("com.android.library") version "8.7.1" apply false
    id("org.jetbrains.kotlin.android") version "2.0.21" apply false
}

tasks.register("clean").configure {
    delete(rootProject.layout.buildDirectory.get().asFile)
}

buildscript {
    repositories {
        google()
    }
    dependencies {
        classpath("androidx.navigation:navigation-safe-args-gradle-plugin:2.8.3")
    }
}
