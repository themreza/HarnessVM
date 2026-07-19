#!/bin/bash
set -euo pipefail

[ -x /config/.hermes/.local/bin/hermes ] || HOME=/config/.hermes \
  HERMES_HOME=/config/.hermes bash -c \
  'set -o pipefail; curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash -s -- --skip-browser'
