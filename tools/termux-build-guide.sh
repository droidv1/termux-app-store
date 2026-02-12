#!/usr/bin/env bash

# Load colors
source "$(dirname "$0")/colors.sh"

cat <<EOF
${CYAN}📦 Termux App Store – Contributor Guide${RESET}
${CYAN}======================================${RESET}

1. ${WHITE}termux-build DOES NOT modify files${RESET}
2. ${WHITE}termux-build is NOT a build system${RESET}
3. ${WHITE}termux-build helps you avoid PR rejection${RESET}

Workflow:
- ${WHITE}write build.sh${RESET}
- run: ${BOLD_BLUE}termux-build lint${RESET}
- run: ${BOLD_BLUE}termux-build doctor${RESET}
- ${WHITE}fix issues manually${RESET}
- ${WHITE}submit PR${RESET}

If termux-build passes:
${BOLD_GREEN}✔ your PR is structurally safe${RESET}
${BOLD_RED}❌ maintainer may still reject (policy reasons)${RESET}

${CYAN}This is a pre-flight checklist, not CI.${RESET}
EOF
