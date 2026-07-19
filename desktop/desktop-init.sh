#!/bin/bash
set -euo pipefail

for directory in ${HARNESSVM_PERSIST_DIRS//,/ }; do
  install -d -o abc -g abc -m 0700 "/config/$directory"
  chown -R abc:abc "/config/$directory"
done

printf '%s\n' '[ "$PWD" != "$HOME" ] || cd /workspace' >>/config/.bashrc
chown abc:abc /config/.bashrc

vscode_config_dir=/config/.config/Code
install -d -o abc -g abc -m 0755 "$vscode_config_dir" "$vscode_config_dir/User"
install -o abc -g abc -m 0644 \
  /defaults/vscode/settings.json "$vscode_config_dir/User/settings.json"

for harness in ${HARNESSVM_HARNESSES//,/ }; do
  /command/s6-setuidgid abc "/opt/harnessvm/harnesses/$harness.sh" \
    || printf 'harnessvm: %s failed\n' "$harness" >&2
done
