#!/bin/bash
set -euo pipefail

# Public egress is allowed. Private destinations require a matching
# per-session HOST:PORT rule.
{
  nft list table inet harnessvm >/dev/null 2>&1 \
    && printf 'delete table inet harnessvm\n'
  cat <<'EOF'
table inet harnessvm {
  set private_v4 {
    type ipv4_addr
    flags interval
    elements = {
      0.0.0.0/8, 10.0.0.0/8, 100.64.0.0/10, 127.0.0.0/8,
      169.254.0.0/16, 172.16.0.0/12, 192.0.0.0/24, 192.168.0.0/16,
      198.18.0.0/15, 224.0.0.0/4, 240.0.0.0/4
    }
  }

  set private_v6 {
    type ipv6_addr
    flags interval
    elements = { ::/128, ::1/128, fc00::/7, fe80::/10, ff00::/8 }
  }

  chain forward {
    type filter hook forward priority -50; policy accept;
EOF

  while read -r network; do
    record=$(docker network inspect --format \
      '{{ index .Options "com.docker.network.bridge.name" }}|{{ index .Labels "io.harnessvm.allow" }}' \
      "$network")
    IFS='|' read -r bridge allow <<<"$record"
    for endpoint in ${allow//,/ }; do
      endpoint=${endpoint%/tcp}
      host=${endpoint%:*}
      port=${endpoint##*:}
      getent ahostsv4 "$host" | awk '!seen[$1]++ { print $1 }' | while read -r address; do
        printf '    iifname "%s" ip daddr %s tcp dport %s accept\n' "$bridge" "$address" "$port"
      done
    done
    printf '    iifname "%s" ip daddr @private_v4 reject with icmpx type admin-prohibited\n' "$bridge"
    printf '    iifname "%s" ip6 daddr @private_v6 reject with icmpx type admin-prohibited\n' "$bridge"
  done < <(docker network ls -q --filter label=io.harnessvm.session)

  printf '  }\n}\n'
} | nft -f -
