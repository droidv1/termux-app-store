#!/usr/bin/env bash

source "$(dirname "$0")/colors.sh"

echo -e "${BOLD_CYAN}# build.sh template (Termux package)${RESET}\n"

echo -e "${BOLD_YELLOW}TERMUX_PKG_HOMEPAGE${RESET}=https://example.com"
echo -e "${BOLD_YELLOW}TERMUX_PKG_DESCRIPTION${RESET}=\"Short description\""
echo -e "${BOLD_YELLOW}TERMUX_PKG_LICENSE${RESET}=\"MIT\""
echo -e "${BOLD_YELLOW}TERMUX_PKG_MAINTAINER${RESET}=\"Your Name <email>\""
echo -e "${BOLD_YELLOW}TERMUX_PKG_VERSION${RESET}=1.0.0"
echo -e "${BOLD_YELLOW}TERMUX_PKG_SRCURL${RESET}=\"https://example.com/\${TERMUX_PKG_VERSION}.tar.gz\""
echo -e "${BOLD_YELLOW}TERMUX_PKG_SHA256${RESET}=<INPUT_SHA256_HERE>"
echo -e "${BOLD_YELLOW}TERMUX_PKG_DEPENDS${RESET}=\"python, bash, and etc\"\n"

echo -e "${BOLD_GREEN}termux_step_make_install() {${RESET}"
echo -e "  install -Dm755 yourtool \$TERMUX_PREFIX/bin/yourtool"
echo -e "${BOLD_GREEN}}${RESET}"
