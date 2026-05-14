#!/usr/bin/env bash
set -euo pipefail

BUMP="${1:-patch}"

if [[ "$BUMP" != "patch" && "$BUMP" != "minor" && "$BUMP" != "major" ]]; then
  echo "Usage: ./release.sh [patch|minor|major]"
  echo "  ./release.sh        # patch +1 (default)"
  echo "  ./release.sh minor  # minor +1, patch reset"
  echo "  ./release.sh major  # major +1, minor & patch reset"
  exit 1
fi

# Get latest tag
LATEST=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
NUM=${LATEST#v}

IFS='.' read -r MAJOR MINOR PATCH <<< "$NUM"

case "$BUMP" in
  patch) PATCH=$((PATCH + 1)) ;;
  minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
  major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
esac

VERSION="v${MAJOR}.${MINOR}.${PATCH}"
NUM_VERSION="${MAJOR}.${MINOR}.${PATCH}"

echo "Releasing $LATEST -> $VERSION ($BUMP)"

# Update version in all extension.yml
for dir in speckit-*/; do
  yml="$dir/extension.yml"
  if [ -f "$yml" ]; then
    sed -i "s/^  version:.*/  version: ${NUM_VERSION}/" "$yml"
    echo "Updated $yml to $NUM_VERSION"
  fi
done

git add speckit-*/extension.yml
git commit -m "release $VERSION"
git push origin main
git tag "$VERSION"
git push origin "$VERSION"

echo "Released $VERSION"
