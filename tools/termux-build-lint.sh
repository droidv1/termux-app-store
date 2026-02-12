#!/usr/bin/env bash
set -eo pipefail

# Load colors
source "$(dirname "$0")/colors.sh"

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
VALIDATOR="$ROOT_DIR/tools/validate-build.sh"
PKG_DIR="$ROOT_DIR/packages"

TARGET="${1:-}"

if [[ -z "$TARGET" ]]; then
    echo -e "${RED}Usage:${RESET}"
    echo -e "  ${GREEN}./termux-build lint packages/<package>/build.sh${RESET}"
    echo -e "  ${GREEN}./termux-build lint <package>${RESET}"
    echo -e "  ${GREEN}./termux-build lint all${RESET}"
    exit 2
fi

if [[ "$TARGET" == "all" ]]; then
    FAIL=0
    for BUILD in "$PKG_DIR"/*/build.sh; do
        echo
        if ! bash "$VALIDATOR" "$BUILD"; then
            FAIL=1
        fi
    done
    exit $FAIL
fi

if [[ -d "$PKG_DIR/$TARGET" ]]; then
    exec bash "$VALIDATOR" "$PKG_DIR/$TARGET/build.sh"
fi

if [[ -f "$TARGET" ]]; then
    exec bash "$VALIDATOR" "$TARGET"
fi

echo -e "${BOLD_RED}❌ ERROR: Invalid target: $TARGET${RESET}"
exit 2
