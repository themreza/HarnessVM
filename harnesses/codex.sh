#!/bin/bash
set -euo pipefail

[ -x "$CODEX_HOME/bin/codex" ] \
  || curl -fsSL https://chatgpt.com/codex/install.sh \
    | CODEX_INSTALL_DIR="$CODEX_HOME/bin" CODEX_NON_INTERACTIVE=1 sh
