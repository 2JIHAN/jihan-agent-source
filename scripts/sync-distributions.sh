#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SOURCE_DIR="$REPO_ROOT/source"
NOTION_WRITER_DIR="$REPO_ROOT/plugins/notion-writer"
VERIFIER_DIR="$REPO_ROOT/plugins/verifier-on-sandbox"
OPENCODE_DIST_DIR="$REPO_ROOT/distributions/opencode-plugin"

# notion-writer plugin: both skills + notion-writer agent only.
mkdir -p \
  "$NOTION_WRITER_DIR/skills/general-doc-rules" \
  "$NOTION_WRITER_DIR/skills/method-doc-rules" \
  "$NOTION_WRITER_DIR/agents"

cp "$SOURCE_DIR/skills/general-doc-rules/SKILL.md" \
  "$NOTION_WRITER_DIR/skills/general-doc-rules/SKILL.md"
cp "$SOURCE_DIR/skills/method-doc-rules/SKILL.md" \
  "$NOTION_WRITER_DIR/skills/method-doc-rules/SKILL.md"
cp "$SOURCE_DIR/agents/notion-writer.md" \
  "$NOTION_WRITER_DIR/agents/notion-writer.md"

# verifier-on-sandbox plugin: verifier agent only.
mkdir -p "$VERIFIER_DIR/agents"
cp "$SOURCE_DIR/agents/verifier-on-sandbox.md" \
  "$VERIFIER_DIR/agents/verifier-on-sandbox.md"

# OpenCode bundled distribution: all skills + all agents in one place.
mkdir -p \
  "$OPENCODE_DIST_DIR/.opencode/skills/general-doc-rules" \
  "$OPENCODE_DIST_DIR/.opencode/skills/method-doc-rules" \
  "$OPENCODE_DIST_DIR/.opencode/agents"

cp "$SOURCE_DIR/skills/general-doc-rules/SKILL.md" \
  "$OPENCODE_DIST_DIR/.opencode/skills/general-doc-rules/SKILL.md"
cp "$SOURCE_DIR/skills/method-doc-rules/SKILL.md" \
  "$OPENCODE_DIST_DIR/.opencode/skills/method-doc-rules/SKILL.md"

for agent in notion-writer verifier-on-sandbox; do
  agent_description=$(awk '/^description: / { sub(/^description: /, ""); print; exit }' "$SOURCE_DIR/agents/$agent.md")

  {
    printf -- "---\n"
    printf "description: %s\n" "$agent_description"
    printf "mode: subagent\n"
    printf -- "---\n\n"
    awk '
      NR == 1 && $0 == "---" { in_frontmatter = 1; next }
      in_frontmatter && $0 == "---" { in_frontmatter = 0; body = 1; next }
      body { print }
    ' "$SOURCE_DIR/agents/$agent.md"
  } > "$OPENCODE_DIST_DIR/.opencode/agents/$agent.md"
done

echo "synced distributions from source"
