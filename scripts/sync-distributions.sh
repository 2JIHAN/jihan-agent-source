#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SOURCE_DIR="$REPO_ROOT/source"
PLUGIN_DIR="$REPO_ROOT/plugins/jihan-agents"
OPENCODE_DIST_DIR="$REPO_ROOT/distributions/opencode-plugin"

AGENTS=(
  notion-writer
  verifier-on-sandbox
  notion-doc-verifier
  notion-verifier-gui
  notion-verifier-concept
)

SKILLS=(
  general-doc-rules
  method-doc-rules
)

# Claude Code plugin: single bundle, all roles flat under agents/, all skills flat under skills/.
mkdir -p "$PLUGIN_DIR/agents" "$PLUGIN_DIR/skills"

# Wipe stale agent/skill files in the plugin dir so removed roles don't linger.
rm -f "$PLUGIN_DIR"/agents/*.md
rm -rf "$PLUGIN_DIR"/skills/*

for agent in "${AGENTS[@]}"; do
  cp "$SOURCE_DIR/agents/$agent.md" "$PLUGIN_DIR/agents/$agent.md"
done

for skill in "${SKILLS[@]}"; do
  mkdir -p "$PLUGIN_DIR/skills/$skill"
  cp "$SOURCE_DIR/skills/$skill/SKILL.md" "$PLUGIN_DIR/skills/$skill/SKILL.md"
done

# OpenCode distribution: same flat layout under .opencode/.
mkdir -p \
  "$OPENCODE_DIST_DIR/.opencode/agents" \
  "$OPENCODE_DIST_DIR/.opencode/skills"

rm -f "$OPENCODE_DIST_DIR/.opencode/agents"/*.md
rm -rf "$OPENCODE_DIST_DIR/.opencode/skills"/*

for skill in "${SKILLS[@]}"; do
  mkdir -p "$OPENCODE_DIST_DIR/.opencode/skills/$skill"
  cp "$SOURCE_DIR/skills/$skill/SKILL.md" \
    "$OPENCODE_DIST_DIR/.opencode/skills/$skill/SKILL.md"
done

for agent in "${AGENTS[@]}"; do
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
