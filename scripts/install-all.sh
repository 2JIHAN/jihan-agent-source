#!/usr/bin/env bash
set -eo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo "error, jq required. install with: brew install jq" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MARKETPLACE_JSON="$REPO_ROOT/.claude-plugin/marketplace.json"

if [ ! -f "$MARKETPLACE_JSON" ]; then
  echo "error, marketplace.json not found at $MARKETPLACE_JSON" >&2
  exit 1
fi

MARKETPLACE_NAME=$(jq -r '.name' "$MARKETPLACE_JSON")

if ! claude plugin marketplace list 2>/dev/null | grep -qE "❯ ${MARKETPLACE_NAME}\$"; then
  echo "registering marketplace ${MARKETPLACE_NAME} from ${REPO_ROOT}"
  claude plugin marketplace add "$REPO_ROOT"
fi

jq -r '.plugins[].name' "$MARKETPLACE_JSON" | while read -r plugin; do
  echo "installing ${plugin}@${MARKETPLACE_NAME}"
  claude plugin install "${plugin}@${MARKETPLACE_NAME}"
done

echo "done. installed plugins:"
claude plugin list
