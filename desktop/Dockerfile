# syntax=docker/dockerfile:1
FROM node:22-bookworm-slim@sha256:6c74791e557ce11fc957704f6d4fe134a7bc8d6f5ca4403205b2966bd488f6b3 AS node
FROM lscr.io/linuxserver/webtop:ubuntu-xfce@sha256:f106549e832cd9b548263d45f81020afd96c4b090a56e1d420e34ce8e4cb36a0

ARG DEBIAN_FRONTEND=noninteractive

RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
      | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg \
    && printf '%s\n' \
      'Types: deb' \
      'URIs: https://packages.microsoft.com/repos/code' \
      'Suites: stable' \
      'Components: main' \
      'Architectures: amd64 arm64 armhf' \
      'Signed-By: /usr/share/keyrings/microsoft.gpg' \
      >/etc/apt/sources.list.d/vscode.sources \
    && apt-get update \
    && apt-get install -y --no-install-recommends code less ripgrep xz-utils \
    && rm -rf /var/lib/apt/lists/*

COPY --from=node /usr/local/ /usr/local/

RUN sed -i 's|^Exec=/usr/share/code/code |Exec=/usr/local/bin/code |' \
      /usr/share/applications/code.desktop \
      /usr/share/applications/code-url-handler.desktop

COPY desktop/code.sh /usr/local/bin/code
COPY harnesses /opt/harnessvm/harnesses
COPY desktop/wallpaper.jpg /usr/share/backgrounds/harnessvm-wallpaper.jpg
COPY desktop/xfce4-desktop.xml /defaults/xfce/xfce4-desktop.xml
COPY desktop/vscode-settings.json /defaults/vscode/settings.json
COPY desktop/vscode-workspace.desktop /usr/share/applications/harnessvm-code.desktop
COPY desktop/vscode-workspace.desktop /etc/xdg/autostart/harnessvm-code.desktop
COPY desktop/desktop-init.sh /custom-cont-init.d/10-harnessvm
RUN chmod 0755 \
      /usr/local/bin/code \
      /opt/harnessvm/harnesses/*.sh \
      /custom-cont-init.d/10-harnessvm

ENV HOME=/config \
    CODEX_HOME=/config/.codex \
    CLAUDE_CONFIG_DIR=/config/.claude/config \
    PI_CODING_AGENT_DIR=/config/.pi/agent \
    HERMES_HOME=/config/.hermes \
    QWEN_HOME=/config/.qwen \
    PATH=/config/.codex/bin:/config/.claude/bin:/config/.opencode/bin:/config/.pi/bin:/config/.hermes/.local/bin:/config/.qwen/bin:/lsiopy/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

EXPOSE 3000
WORKDIR /workspace
