#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCODE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
MANIFEST="$OPENCODE_CONFIG_DIR/.jihan-agent-source.manifest"

mkdir -p \
  "$OPENCODE_CONFIG_DIR/skills/general-doc-rules" \
  "$OPENCODE_CONFIG_DIR/skills/method-doc-rules" \
  "$OPENCODE_CONFIG_DIR/agents"

# 이번 install 에서 owning 할 파일 목록
new_files=(
  "skills/general-doc-rules/SKILL.md"
  "skills/method-doc-rules/SKILL.md"
  "agents/notion-writer.md"
  "agents/verifier-on-sandbox.md"
)

# 직전 install 이 owning 했지만 이번엔 빠진 stale 파일 제거
if [[ -f "$MANIFEST" ]]; then
  while IFS= read -r prev; do
    [[ -z "$prev" ]] && continue
    keep=0
    for cur in "${new_files[@]}"; do
      [[ "$prev" == "$cur" ]] && keep=1 && break
    done
    if [[ "$keep" -eq 0 ]]; then
      target="$OPENCODE_CONFIG_DIR/$prev"
      if [[ -f "$target" ]]; then
        rm "$target"
        echo "removed stale: $prev"
      fi
    fi
  done < "$MANIFEST"
fi

cp "$SCRIPT_DIR/.opencode/skills/general-doc-rules/SKILL.md" \
  "$OPENCODE_CONFIG_DIR/skills/general-doc-rules/SKILL.md"
cp "$SCRIPT_DIR/.opencode/skills/method-doc-rules/SKILL.md" \
  "$OPENCODE_CONFIG_DIR/skills/method-doc-rules/SKILL.md"
cp "$SCRIPT_DIR/.opencode/agents/notion-writer.md" \
  "$OPENCODE_CONFIG_DIR/agents/notion-writer.md"
cp "$SCRIPT_DIR/.opencode/agents/verifier-on-sandbox.md" \
  "$OPENCODE_CONFIG_DIR/agents/verifier-on-sandbox.md"

printf "%s\n" "${new_files[@]}" > "$MANIFEST"

echo "installed OpenCode skills and agents to $OPENCODE_CONFIG_DIR"
