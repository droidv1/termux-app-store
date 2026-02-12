#!/usr/bin/env bash
set -eo pipefail

source "$(dirname "$0")/colors.sh"

PKG="${1:-}"

if [[ -z "$PKG" ]]; then
  echo -e "${BOLD_RED}❌ Usage: termux-build explain <package>${RESET}"
  exit 1
fi

FILE="packages/$PKG/build.sh"

if [[ ! -f "$FILE" ]]; then
  echo -e "${BOLD_RED}❌ build.sh not found for package: $PKG${RESET}"
  exit 1
fi

source "$FILE" || true

echo -e "${CYAN}🧠 PR Risk Analysis: $PKG${RESET}"
echo -e "${CYAN}========================${RESET}"

RISK=0
WARN=0

fatal() {
  echo -e "${BOLD_RED}❌ FATAL : $1${RESET}"
  RISK=1
}

warn() {
  echo -e "${BOLD_YELLOW}⚠️  WARN  : $1${RESET}"
  WARN=1
}

ok() {
  echo -e "${BOLD_GREEN}✔ OK     : $1${RESET}"
}

[[ -z "${TERMUX_PKG_SRCURL:-}"   ]] && fatal "TERMUX_PKG_SRCURL missing"   || ok "SRCURL present"
[[ -z "${TERMUX_PKG_SHA256:-}"  ]] && fatal "TERMUX_PKG_SHA256 missing"  || ok "SHA256 present"
[[ -z "${TERMUX_PKG_VERSION:-}" ]] && fatal "TERMUX_PKG_VERSION missing" || ok "VERSION present"
[[ -z "${TERMUX_PKG_LICENSE:-}" ]] && fatal "TERMUX_PKG_LICENSE missing" || ok "LICENSE present"

[[ -z "${TERMUX_PKG_HOMEPAGE:-}" ]] && warn "No homepage set (optional but recommended)"
[[ -n "${TERMUX_PKG_DESCRIPTION:-}" && ${#TERMUX_PKG_DESCRIPTION} -lt 15 ]] \
  && warn "Description is very short"

echo
if [[ $RISK -eq 1 ]]; then
  echo -e "${BOLD_RED}🚫 High risk: PR likely to be rejected${RESET}"
elif [[ $WARN -eq 1 ]]; then
  echo -e "${BOLD_YELLOW}⚠️  Medium risk: PR may get reviewer comments${RESET}"
else
  echo -e "${BOLD_GREEN}🟢 Low risk: PR looks clean and review-friendly${RESET}"
fi

echo
echo -e "${CYAN}(Analysis only, no changes made)${RESET}"
