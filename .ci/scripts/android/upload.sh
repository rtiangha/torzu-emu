#!/bin/bash -ex

# SPDX-FileCopyrightText: 2023 torzu Emulator Project
# SPDX-License-Identifier: GPL-3.0-or-later

. ./.ci/scripts/common/pre-upload.sh

REV_NAME="torzu-${GITDATE}-${GITREV}"

BUILD_FLAVOR="mainline"

BUILD_TYPE_LOWER="release"
BUILD_TYPE_UPPER="Release"
if [ "${GITHUB_REPOSITORY}" == "torzu-emu/torzu" ]; then
    BUILD_TYPE_LOWER="relWithDebInfo"
    BUILD_TYPE_UPPER="RelWithDebInfo"
fi

cp src/android/app/build/outputs/apk/"${BUILD_FLAVOR}/${BUILD_TYPE_LOWER}/app-${BUILD_FLAVOR}-${BUILD_TYPE_LOWER}.apk" \
  "artifacts/${REV_NAME}.apk"
