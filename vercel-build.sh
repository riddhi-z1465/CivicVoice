#!/bin/bash
set -e

echo "=== CivicVoice Vercel Build Step ==="
echo "Node version: $(node -v)"
echo "Git version: $(git --version)"

# Install Flutter if not cached
if [ ! -d "$HOME/flutter" ]; then
  echo "Cloning Flutter SDK (stable channel)..."
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$HOME/flutter"
fi

export PATH="$HOME/flutter/bin:$PATH"

echo "=== Flutter Environment ==="
flutter --version
flutter config --enable-web

echo "=== Getting dependencies ==="
flutter pub get

echo "=== Building Flutter Web for Release ==="
flutter build web --release

echo "=== Flutter build completed successfully ==="
