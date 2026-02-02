#!/usr/bin/env bash
# Ensure a local jq binary exists under scripts/.bin (sandboxed, does not touch system jq).
# Outputs the path to jq on stdout; exits 1 on failure.
# Prefer CLAUDE_PLUGIN_ROOT/scripts when set (same as hooks/SKILL.md); else derive from script location.

set -e
if [ -n "${CLAUDE_PLUGIN_ROOT:-}" ]; then
  SCRIPT_DIR="$(cd "${CLAUDE_PLUGIN_ROOT}/scripts" && pwd)"
else
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
fi
BIN_DIR="$SCRIPT_DIR/.bin"
JQ="$BIN_DIR/jq"
JQ_VERSION="1.7.2"

if [ -x "$JQ" ]; then
  echo "$JQ"
  exit 0
fi

# Detect platform for jqlang/jq release assets: jq-1.7.2-<os>-<arch>
OS=$(uname -s)
ARCH=$(uname -m)
case "$OS" in
  Linux)   OS_TAG="linux" ;;
  Darwin)  OS_TAG="osx" ;;
  *) echo "ensue-jq: unsupported OS $OS" >&2; exit 1 ;;
esac
case "$ARCH" in
  x86_64)       ARCH_TAG="amd64" ;;
  aarch64|arm64) ARCH_TAG="arm64" ;;
  armv7l)       ARCH_TAG="armhf" ;;
  i686|i386)    ARCH_TAG="i386" ;;
  *) echo "ensue-jq: unsupported arch $ARCH" >&2; exit 1 ;;
esac

ASSET="jq-${JQ_VERSION}-${OS_TAG}-${ARCH_TAG}"
URL="https://github.com/jqlang/jq/releases/download/jq-${JQ_VERSION}/${ASSET}"
mkdir -p "$BIN_DIR"
if ! curl -sLf "$URL" -o "$JQ"; then
  echo "ensue-jq: failed to download $URL" >&2
  exit 1
fi
chmod +x "$JQ"
echo "$JQ"
