#!/bin/bash
set -euo pipefail

[ -x /config/.claude/bin/claude ] \
  || npm install -g --prefix /config/.claude --no-fund --no-audit @anthropic-ai/claude-code@latest
