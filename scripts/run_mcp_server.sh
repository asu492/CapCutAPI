#!/usr/bin/env sh
# Launch the CapCutAPI MCP server over stdio.
#
# Used by the project-scoped .mcp.json so Claude Code (or any MCP client) can start the
# server without hard-coding an absolute path. Works from any working directory.
#
# Interpreter selection, first match wins:
#   1. $CAPCUT_PYTHON
#   2. a virtualenv in the repo root: venv-mcp/, .venv/, venv/
#   3. python3 on PATH
set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

PY="${CAPCUT_PYTHON:-}"
if [ -z "$PY" ]; then
  for candidate in venv-mcp/bin/python .venv/bin/python venv/bin/python; do
    if [ -x "$ROOT/$candidate" ]; then
      PY="$ROOT/$candidate"
      break
    fi
  done
fi
PY="${PY:-python3}"

# stdout is the MCP channel; nothing else may be written to it before exec.
exec "$PY" "$ROOT/mcp_server.py" "$@"
