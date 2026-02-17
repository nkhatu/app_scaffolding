#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2026 The Khatu Family Trust
# -----------------------------------------------------------------------------
# File: scripts/apply_app_icons.sh
# File Version: 1.2.0
# Framework : Core App Tech Utilities (Catu) Framework
# Author: Neil Khatu
# -----------------------------------------------------------------------------

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <path-to-flutter-app>"
  exit 1
fi

TARGET_APP="$(cd "$1" && pwd)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ICON_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)/assets/icons"

ANDROID_DST="$TARGET_APP/android/app/src/main/res"
IOS_DST="$TARGET_APP/ios/Runner/Assets.xcassets/AppIcon.appiconset"

if [[ ! -d "$ANDROID_DST" ]]; then
  echo "Android res directory not found: $ANDROID_DST"
  exit 1
fi

if [[ ! -d "$IOS_DST" ]]; then
  echo "iOS AppIcon directory not found: $IOS_DST"
  exit 1
fi

echo "Applying Android launcher icons..."
for dpi in mdpi hdpi xhdpi xxhdpi xxxhdpi; do
  mkdir -p "$ANDROID_DST/mipmap-$dpi"
  cp "$ICON_ROOT/android/mipmap-$dpi/ic_launcher.png" \
    "$ANDROID_DST/mipmap-$dpi/ic_launcher.png"
  if [[ -f "$ICON_ROOT/android/mipmap-$dpi/ic_launcher_round.png" ]]; then
    cp "$ICON_ROOT/android/mipmap-$dpi/ic_launcher_round.png" \
      "$ANDROID_DST/mipmap-$dpi/ic_launcher_round.png"
  fi
done

echo "Applying iOS app icons..."
cp "$ICON_ROOT/ios/AppIcon.appiconset/"* "$IOS_DST/"

echo "Done. Icons applied to:"
echo "  Android: $ANDROID_DST"
echo "  iOS:     $IOS_DST"
