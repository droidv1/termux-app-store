#!/usr/bin/env bash
set -eo pipefail

source "$(dirname "$0")/colors.sh"

PKG="${1:-}"

if [[ -z "$PKG" ]]; then
  echo -e "${BOLD_RED}❌ Usage: termux-build suggest <package>${RESET}"
  exit 1
fi

FILE="packages/$PKG/build.sh"

if [[ ! -f "$FILE" ]]; then
  echo -e "${BOLD_RED}❌ build.sh not found for package: $PKG${RESET}"
  exit 1
fi

source "$FILE" || true

echo -e "${BOLD_CYAN}💡 Suggestions for $PKG${RESET}"
echo -e "${CYAN}=======================${RESET}"

SUGGESTIONS=0

suggest_missing() {
  if [[ -z "${!1:-}" ]]; then
    echo -e "${YELLOW}- add $1=\"...\"${RESET}"
    SUGGESTIONS=1
  fi
}

suggest_quality() {
  local val="${!1:-}"
  if [[ -n "$val" && ${#val} -lt 10 ]]; then
    echo -e "${MAGENTA}- consider improving $1 (too short)${RESET}"
    SUGGESTIONS=1
  fi
}

# Required fields
suggest_missing TERMUX_PKG_HOMEPAGE
suggest_missing TERMUX_PKG_DESCRIPTION
suggest_missing TERMUX_PKG_LICENSE
suggest_missing TERMUX_PKG_MAINTAINER
suggest_missing TERMUX_PKG_VERSION
suggest_missing TERMUX_PKG_SRCURL
suggest_missing TERMUX_PKG_SHA256

# Quality hints
suggest_quality TERMUX_PKG_DESCRIPTION
suggest_quality TERMUX_PKG_HOMEPAGE

if [[ $SUGGESTIONS -eq 0 ]]; then
  echo -e "${BOLD_GREEN}✔ No suggestions — build.sh already looks solid${RESET}"
fi
