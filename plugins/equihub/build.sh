#!/usr/bin/env bash
# Builds an installable .plugin bundle for one environment.
#
#   ./build.sh local  -> dist/equihub-local.plugin (http://localhost:8080/mcp)
#   ./build.sh dev    -> dist/equihub-dev.plugin   (https://dev-3200.equihub.io/mcp)
#   ./build.sh prod   -> dist/equihub.plugin       (needs EQUIHUB_PROD_MCP_URL)
#
# Transport (EQUIHUB_TRANSPORT):
#   http (default) - direct Streamable HTTP; Claude runs the sign-in itself
#                    (the server answers 401 + WWW-Authenticate). No Node.js needed.
#   mcp-remote     - stdio bridge through npx; the bridge opens the browser to
#                    sign in. Needs Node.js. Use it for a server Claude cannot reach.
#
# Every variant keeps the plugin name "equihub" so tool names
# (mcp__plugin_equihub_equihub__*) stay the same: install one variant at a time.
set -euo pipefail

ENV="${1:-}"
ROOT="$(cd "$(dirname "$0")" && pwd)"

case "$ENV" in
  local)
    URL="${EQUIHUB_LOCAL_MCP_URL:-http://localhost:8080/mcp}"
    OUT="$ROOT/dist/equihub-local.plugin"
    LABEL=" (local)"
    ;;
  dev)
    URL="${EQUIHUB_DEV_MCP_URL:-https://dev-3200.equihub.io/mcp}"
    OUT="$ROOT/dist/equihub-dev.plugin"
    LABEL=" (dev)"
    ;;
  prod)
    URL="${EQUIHUB_PROD_MCP_URL:?Set EQUIHUB_PROD_MCP_URL to the deployed https://.../mcp endpoint}"
    OUT="$ROOT/dist/equihub.plugin"
    LABEL=""
    ;;
  *)
    echo "Usage: $0 local|dev|prod" >&2
    exit 1
    ;;
esac

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

cp -R "$ROOT/.claude-plugin" "$ROOT/skills" "$ROOT/README.md" "$STAGE/"

# MCP server, URL baked in.
# local defaults to mcp-remote: localhost is only reachable from this machine.
if [ "$ENV" = local ]; then DEFAULT_TRANSPORT=mcp-remote; else DEFAULT_TRANSPORT=http; fi
TRANSPORT="${EQUIHUB_TRANSPORT:-$DEFAULT_TRANSPORT}"
case "$TRANSPORT" in
  mcp-remote)
    jq -n --arg url "$URL" \
      '{mcpServers: {equihub: {command: "npx", args: ["-y", "mcp-remote", $url]}}}' > "$STAGE/.mcp.json" ;;
  http)
    jq -n --arg url "$URL" \
      '{mcpServers: {equihub: {type: "http", url: $url}}}' > "$STAGE/.mcp.json" ;;
  *) echo "EQUIHUB_TRANSPORT must be mcp-remote or http" >&2; exit 1 ;;
esac

# Label the variant so it is recognisable once installed.
jq --arg label "$LABEL" '.description += $label' \
  "$STAGE/.claude-plugin/plugin.json" > "$STAGE/plugin.json.tmp"
mv "$STAGE/plugin.json.tmp" "$STAGE/.claude-plugin/plugin.json"

# The bundle is installed on its own, so it carries a one-plugin marketplace
# made from the parent marketplace's entry for this plugin.
MARKETPLACE="$ROOT/../../.claude-plugin/marketplace.json"
NAME="$(jq -r .name "$ROOT/.claude-plugin/plugin.json")"
jq --arg name "$NAME" --arg label "$LABEL" '
  .plugins |= map(select(.name == $name) | .source = "./" | .description += $label)' \
  "$MARKETPLACE" > "$STAGE/.claude-plugin/marketplace.json"

mkdir -p "$ROOT/dist"
rm -f "$OUT"
(cd "$STAGE" && zip -qrX "$OUT" . -x '*.DS_Store')

echo "Built $OUT -> $URL ($TRANSPORT)"
