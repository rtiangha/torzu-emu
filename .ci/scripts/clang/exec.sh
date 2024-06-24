#!/bin/bash -ex

# SPDX-FileCopyrightText: 2021 torzu Emulator Project
# SPDX-License-Identifier: GPL-2.0-or-later

mkdir -p "ccache"  || true
chmod a+x ./.ci/scripts/clang/docker.sh
# the UID for the container torzu user is 1027
sudo chown -R 1027 ./
docker run -e ENABLE_COMPATIBILITY_REPORTING -e CCACHE_DIR=/torzu/ccache -v "$(pwd):/torzu" -w /torzu torzuemu/build-environments:linux-fresh /bin/bash /torzu/.ci/scripts/clang/docker.sh "$1"
sudo chown -R $UID ./
