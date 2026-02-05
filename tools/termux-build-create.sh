#!/usr/bin/env bash
set -Eeuo pipefail

PKG="${1:-}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG_DIR="$ROOT/packages"
TEMPLATE="$ROOT/template/build.sh"

die() {
  echo "❌ $*" >&2
  exit 1
}

info() {
  echo "ℹ $*"
}

ok() {
  echo "✔ $*"
}

[[ -z "$PKG" ]] && die "Usage: ./termux-build create <package-name>"

if [[ ! "$PKG" =~ ^[a-z0-9._+-]+$ ]]; then
  die "Invalid package name: $PKG"
fi

TARGET="$PKG_DIR/$PKG"

[[ -d "$TARGET" ]] && die "Package already exists: $PKG"
[[ -f "$TEMPLATE" ]] || die "Template not found: template/build.sh"

info "Creating package: $PKG"

mkdir -p "$TARGET"
cp "$TEMPLATE" "$TARGET/build.sh"
chmod +x "$TARGET/build.sh"

ok "Package created:"
echo "  → packages/$PKG/build.sh"

echo
echo "============================================="
info "Next steps:"
echo "  - Edit file build.sh"
info "  Recommend for new user:"
echo "  - nano packages/$PKG/build.sh"
info "  After completing the build.sh file:"
echo "  Step 1)"
echo "  Check installing your package"
echo "     - Run: bash build-packages.sh $PKG"
echo "     - Run: $PKG"
echo "  Step 2)"
ok "  If Successful, next for validation:"
echo "     - Run: ./termux-build lint $PKG"
die "  If error not installed, not run package:"
echo "     - Create issue: (Support/Help Request)"
echo "     https://github.com/djunekz/termux-app-store/issues"
echo "=============================================="
