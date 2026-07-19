#!/bin/bash
set -euo pipefail

bin=/config/.opencode/bin
[ ! -x "$bin/opencode-real" ] || exit 0
npm install -g --prefix /config/.opencode --no-fund --no-audit opencode-ai@latest
mv "$bin/opencode" "$bin/opencode-real"
printf '%s\n' '#!/bin/sh' \
  'exec env XDG_CONFIG_HOME=/config/.opencode/config XDG_DATA_HOME=/config/.opencode/data XDG_CACHE_HOME=/config/.opencode/cache /config/.opencode/bin/opencode-real "$@"' \
  >"$bin/opencode"
chmod 0755 "$bin/opencode"
