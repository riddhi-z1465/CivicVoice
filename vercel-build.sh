#!/bin/bash
set -e

if [ ! -d "flutter" ]; then
  echo "Cloning Flutter SDK..."
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable
fi

export PATH="$PWD/flutter/bin:$PATH"

flutter doctor -v
flutter config --enable-web
flutter pub get
flutter build web --release
