#!/bin/bash
set -euo pipefail

[ -x /config/.qwen/bin/qwen ] \
  || npm install -g --prefix /config/.qwen --no-fund --no-audit @qwen-code/qwen-code@latest
