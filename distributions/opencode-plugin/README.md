# OpenCode distribution

OpenCode 배포물. `source/` 아래 단일 원본에서 생성된 skills 와 notion-writer agent 를 포함한다.

## 구조

```text
.opencode/
├── agents/
│   └── notion-writer.md
└── skills/
    ├── general-doc-rules/SKILL.md
    └── method-doc-rules/SKILL.md
```

## 설치

전역 OpenCode 설정에 설치한다.

```bash
~/jihan-agent-source/distributions/opencode-plugin/install-global.sh
```

## 업데이트

직접 수정하지 않는다. 원본은 repo 루트의 `source/` 아래 파일이다.

```bash
scripts/sync-distributions.sh
distributions/opencode-plugin/install-global.sh
```

OpenCode 공식 탐색 경로 기준으로 skills 는 `~/.config/opencode/skills/<name>/SKILL.md`, agents 는 `~/.config/opencode/agents/<name>.md` 에 설치된다.
