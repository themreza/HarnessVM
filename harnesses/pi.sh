#!/bin/bash
set -euo pipefail

[ -x /config/.pi/bin/pi ] \
  || npm install -g --ignore-scripts --prefix /config/.pi --no-fund --no-audit @earendil-works/pi-coding-agent@latest
