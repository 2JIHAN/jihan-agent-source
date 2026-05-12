#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SOURCE_DIR="$REPO_ROOT/source"
CLAUDE_PLUGIN_DIR="$REPO_ROOT/plugins/notion-writer"
OPENCODE_DIST_DIR="$REPO_ROOT/distributions/opencode-plugin"

mkdir -p \
  "$CLAUDE_PLUGIN_DIR/skills/general-doc-rules" \
  "$CLAUDE_PLUGIN_DIR/skills/method-doc-rules" \
  "$CLAUDE_PLUGIN_DIR/agents" \
  "$OPENCODE_DIST_DIR/.opencode/skills/general-doc-rules" \
  "$OPENCODE_DIST_DIR/.opencode/skills/method-doc-rules" \
  "$OPENCODE_DIST_DIR/.opencode/agents"

cp "$SOURCE_DIR/skills/general-doc-rules/SKILL.md" \
  "$CLAUDE_PLUGIN_DIR/skills/general-doc-rules/SKILL.md"
cp "$SOURCE_DIR/skills/method-doc-rules/SKILL.md" \
  "$CLAUDE_PLUGIN_DIR/skills/method-doc-rules/SKILL.md"
cp "$SOURCE_DIR/agents/writer.md" \
  "$CLAUDE_PLUGIN_DIR/agents/writer.md"

cp "$SOURCE_DIR/skills/general-doc-rules/SKILL.md" \
  "$OPENCODE_DIST_DIR/.opencode/skills/general-doc-rules/SKILL.md"
cp "$SOURCE_DIR/skills/method-doc-rules/SKILL.md" \
  "$OPENCODE_DIST_DIR/.opencode/skills/method-doc-rules/SKILL.md"

writer_description=$(awk '/^description: / { sub(/^description: /, ""); print; exit }' "$SOURCE_DIR/agents/writer.md")

{
  printf -- "---\n"
  printf "description: %s\n" "$writer_description"
  printf "mode: subagent\n"
  printf -- "---\n\n"
  awk '
    NR == 1 && $0 == "---" { in_frontmatter = 1; next }
    in_frontmatter && $0 == "---" { in_frontmatter = 0; body = 1; next }
    body { print }
  ' "$SOURCE_DIR/agents/writer.md"
} > "$OPENCODE_DIST_DIR/.opencode/agents/writer.md"

echo "synced distributions from source"
