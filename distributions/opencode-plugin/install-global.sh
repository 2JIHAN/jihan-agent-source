#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCODE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"

mkdir -p \
  "$OPENCODE_CONFIG_DIR/skills/general-doc-rules" \
  "$OPENCODE_CONFIG_DIR/skills/method-doc-rules" \
  "$OPENCODE_CONFIG_DIR/agents"

cp "$SCRIPT_DIR/.opencode/skills/general-doc-rules/SKILL.md" \
  "$OPENCODE_CONFIG_DIR/skills/general-doc-rules/SKILL.md"
cp "$SCRIPT_DIR/.opencode/skills/method-doc-rules/SKILL.md" \
  "$OPENCODE_CONFIG_DIR/skills/method-doc-rules/SKILL.md"
cp "$SCRIPT_DIR/.opencode/agents/notion-writer.md" \
  "$OPENCODE_CONFIG_DIR/agents/notion-writer.md"

echo "installed OpenCode skills and notion-writer agent to $OPENCODE_CONFIG_DIR"
