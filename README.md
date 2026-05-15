# jihan-agent-source

Claude Code 와 OpenCode 에 배포할 역할 agent 와 doc skill 의 단일 원본. OSST (One Source Single Truth) 원칙에 따라 `source/` 아래 파일만 직접 수정하고, 각 런타임 배포물은 sync 스크립트로 생성한다.

마켓플레이스 이름과 단일 플러그인 이름 모두 `jihan-agents`.

## 구조

```text
jihan-agent-source/
├── source/                              # OSST 원본
│   ├── agents/
│   │   ├── notion-writer.md
│   │   ├── verifier-on-sandbox.md
│   │   ├── notion-doc-verifier.md
│   │   ├── notion-verifier-gui.md
│   │   └── notion-verifier-concept.md
│   └── skills/
│       ├── general-doc-rules/SKILL.md
│       └── method-doc-rules/SKILL.md
├── plugins/
│   └── jihan-agents/                    # Claude Code 통합 플러그인 (5 agents + 2 skills)
├── distributions/
│   └── opencode-plugin/                 # OpenCode 배포물
├── .claude-plugin/
│   └── marketplace.json
└── scripts/
    ├── install-all.sh
    └── sync-distributions.sh
```

## 수록 항목

| 이름                          | 유형    | 설명                                                                          |
| --------------------------- | ----- | --------------------------------------------------------------------------- |
| `general-doc-rules`         | skill | 문서 작성 공통 규칙                                                                 |
| `method-doc-rules`          | skill | 단계별 방법 문서 작성 규칙                                                             |
| `notion-writer`             | agent | Notion 페이지 작성, 수정 전담                                                        |
| `verifier-on-sandbox`       | agent | 문서 안의 셸 명령을 일회용 Ubuntu Docker 컨테이너에서 실행하고 pass/fail 보고                       |
| `notion-doc-verifier`       | agent | Notion how-to 문서 종합 검증 오케스트레이터. 블록을 CLI/GUI/concept lane 으로 분기하고 인라인 코멘트로 피드백 |
| `notion-verifier-gui`       | agent | GUI lane. 문서가 참조하는 공개 URL 가용성과 UI 라벨을 ghostdesk + WebFetch 로 확인              |
| `notion-verifier-concept`   | agent | Concept lane. 죽은 링크, 누락 단계, 모호한 지시, 출처와의 사실 불일치 검토                          |

## Claude Code 설치

```bash
claude plugin marketplace add https://github.com/2JIHAN/jihan-agent-source
claude plugin install jihan-agents@jihan-agents
```

설치 확인.

```bash
claude plugin list
```

## OpenCode 설치

OpenCode 전역 config 에 skills 와 agent 를 설치한다.

```bash
git clone https://github.com/2JIHAN/jihan-agent-source ~/jihan-agent-source
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
   $EDITOR source/skills/method-doc-rules/SKILL.md
   ```
2. 배포물 동기화.
   ```bash
   scripts/sync-distributions.sh
   ```
3. 필요한 런타임에 반영.
   ```bash
   distributions/opencode-plugin/install-global.sh
   claude plugin marketplace update jihan-agents
   claude plugin install jihan-agents@jihan-agents
   ```
4. 변경 사항 커밋 후 푸시.
   ```bash
   git add -A
   git commit -m "..."
   git push
   ```

## 새 역할 추가

1. `source/agents/<new-role>.md` 작성. frontmatter 의 `name`, `description`, `model` 채우기.
2. `scripts/sync-distributions.sh` 의 `AGENTS=()` 배열 끝에 새 이름 한 줄 추가.
3. `scripts/sync-distributions.sh` 실행. `plugins/jihan-agents/agents/` 와 OpenCode 배포물에 자동 복사.
4. 커밋, 푸시. 사용자는 `claude plugin marketplace update jihan-agents` 한 번이면 반영.

## 규칙 변경 원칙

룰에 대한 피드백을 받으면 로컬 메모리, `CLAUDE.md`, 개별 프로젝트 메모리에 저장하지 않고 `source/` 아래 원본을 수정한 뒤 `scripts/sync-distributions.sh` 로 배포물을 갱신한다. 단일 원본을 유지하기 위함.
