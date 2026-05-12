# jihan-agent-source

Claude Code 와 OpenCode 에 배포할 에이전트 규칙, skills, agents 의 단일 원본. OSST (One Source Single Truth) 원칙에 따라 `source/` 아래 파일만 직접 수정하고, 각 런타임 배포물은 sync 스크립트로 생성한다.

## 구조

```text
jihan-agent-source/
├── source/
│   ├── agents/
│   │   └── notion-writer.md
│   └── skills/
│       ├── general-doc-rules/SKILL.md
│       └── method-doc-rules/SKILL.md
├── plugins/
│   └── notion-writer/                  # Claude Code marketplace 호환 배포물
├── distributions/
│   └── opencode-plugin/                # OpenCode 배포물
├── .claude-plugin/
│   └── marketplace.json
└── scripts/
    ├── install-all.sh
    └── sync-distributions.sh
```

루트의 `.claude-plugin/` 과 `plugins/` 구조는 Claude Code marketplace 호환 배포를 위한 것이다. Claude marketplace 이름은 `jihan-agents`.

## 수록 항목


| 이름                  | 유형    | 설명              |
| ------------------- | ----- | --------------- |
| `general-doc-rules` | skill | 문서 작성 공통 규칙     |
| `method-doc-rules`  | skill | 단계별 방법 문서 작성 규칙 |
| `notion-writer`     | agent | 문서 작성 전담 에이전트   |


## Claude Code 설치

전체 설치.

```bash
git clone https://github.com/2JIHAN/jihan-agent-source ~/jihan-agent-source
~/jihan-agent-source/scripts/install-all.sh
```

`jq` 가 필요하므로 없으면 `brew install jq` 먼저.

단일 plugin 설치.

```bash
claude plugin marketplace add https://github.com/2JIHAN/jihan-agent-source
claude plugin install notion-writer@jihan-agents
```

설치 확인.

```bash
claude plugin list
```

## OpenCode 설치

OpenCode 전역 config 에 skills 와 notion-writer agent 를 설치한다.

```bash
~/jihan-agent-source/distributions/opencode-plugin/install-global.sh
```

OpenCode 는 다음 경로에서 자동 발견한다.

```text
~/.config/opencode/skills/<name>/SKILL.md
~/.config/opencode/agents/<name>.md
```

## 업데이트 흐름

1. `source/` 아래 원본만 수정.
  ```bash
    $EDITOR ~/jihan-agent-source/source/skills/method-doc-rules/SKILL.md
  ```
2. 배포물 동기화.
  ```bash
    cd ~/jihan-agent-source
    scripts/sync-distributions.sh
  ```
3. 필요한 런타임에 반영.
  ```bash
    distributions/opencode-plugin/install-global.sh
    claude plugin update notion-writer
  ```
4. 변경 사항 커밋 후 푸시.
  ```bash
    git add -A
    git commit -m "Update agent document rules"
    git push
  ```

## 확장

새 규칙, skill, agent 는 먼저 `source/` 아래에 추가한다. 이후 `scripts/sync-distributions.sh` 에 Claude Code 와 OpenCode 배포 규칙을 추가한다.

## 규칙 변경 원칙

룰에 대한 피드백을 받으면 로컬 메모리, `CLAUDE.md`, 개별 프로젝트 메모리에 저장하지 않고 `source/` 아래 원본을 수정한 뒤 `scripts/sync-distributions.sh` 로 배포물을 갱신한다. 단일 원본을 유지하기 위함.