#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <WINCC_OA_BIN> <PROJECT_NAME> <SCRIPT_PATH>"
  echo "Example: $0 /opt/WinCC_OA/3.21/bin MyProject /home/user/WinCC_OA_Proj/MyProject/scripts/create_topology_dpt.ctl"
  exit 1
fi

WINCC_OA_BIN="$1"
PROJECT_NAME="$2"
SCRIPT_PATH="$3"
SCRIPT_LIST="$(mktemp /tmp/create_topology_dpt.XXXXXX.lst)"

if [[ ! -x "$WINCC_OA_BIN/WCCOActrl" ]]; then
  echo "ERROR: WCCOActrl not found or not executable in '$WINCC_OA_BIN'"
  exit 1
fi

if [[ ! -f "$SCRIPT_PATH" ]]; then
  echo "ERROR: script not found '$SCRIPT_PATH'"
  exit 1
fi

export PATH="$WINCC_OA_BIN:$PATH"
export LD_LIBRARY_PATH="$WINCC_OA_BIN:${LD_LIBRARY_PATH:-}"

printf '%s\n' "$SCRIPT_PATH" > "$SCRIPT_LIST"
trap 'rm -f "$SCRIPT_LIST"' EXIT

echo "Running WinCC OA CTRL script list..."
"$WINCC_OA_BIN/WCCOActrl" -proj "$PROJECT_NAME" -f "$SCRIPT_LIST"
