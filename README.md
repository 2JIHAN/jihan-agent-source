# claude-code-plugin-pack

개인용 Claude Code 플러그인 팩 (마켓플레이스). 룰, 에이전트, 스킬, 훅을 관심사 단위로 묶어 sub-plugin 으로 호스팅한다. 다른 머신에서 한 줄로 받아 쓰고, 새 관심사가 생기면 `plugins/<name>/` 디렉터리를 추가하는 식으로 확장한다.

## 구조

```
claude-code-plugin-pack/        ← 마켓플레이스 루트
├── .claude-plugin/
│   └── marketplace.json        ← 마켓플레이스 정의 + plugin 목록
└── plugins/
    └── notion-writer/          ← plugin 1: Notion 문서 작성 규칙 + writer 에이전트
        ├── .claude-plugin/
        │   └── plugin.json
        ├── agents/
        │   └── writer.md
        └── skills/
            ├── general-doc-rules/SKILL.md
            └── method-doc-rules/SKILL.md
```

스코프, `@` 뒤는 마켓플레이스 이름 (이 repo 이름), `@` 앞은 그 안의 plugin 이름.

## 수록된 plugin

| plugin | 설명 |
| --- | --- |
| `notion-writer` | Notion 문서 작성 규칙 (general + method) 과 writer 에이전트 |

## 설치

```bash
claude plugin marketplace add https://github.com/2JIHAN/claude-code-plugin-pack
claude plugin install notion-writer@claude-code-plugin-pack
```

로컬 개발 중에는 GitHub 없이 디렉터리 경로로도 설치 가능.

```bash
claude plugin marketplace add ~/claude-code-plugin-pack
claude plugin install notion-writer@claude-code-plugin-pack
```

설치 확인.

```bash
claude plugin list
```

## 업데이트 흐름

1. 로컬에서 룰 또는 에이전트 정의 편집.

    ```bash
    $EDITOR ~/claude-code-plugin-pack/plugins/notion-writer/skills/method-doc-rules/SKILL.md
    ```
2. 변경 사항 커밋 후 푸시.

    ```bash
    cd ~/claude-code-plugin-pack
    git add -A
    git commit -m "docs: ..."
    git push
    ```
3. 다른 머신에서 최신 반영.

    ```bash
    claude plugin update notion-writer
    ```

## 사용

- 문서 작성 요청을 받으면 Claude 가 `general-doc-rules` skill 을 자동으로 적용한다.
- 단계별 실행 가이드, 설치/설정/테스트 절차를 요청하면 추가로 `method-doc-rules` skill 이 함께 적용된다.
- 전담 에이전트가 필요하면 `writer` 에이전트를 호출.

## 확장

새 관심사 (예 `code-review`, `research`) 를 추가하려면 다음 단계를 따른다.

1. `plugins/<name>/` 디렉터리 생성.
2. 그 안에 `.claude-plugin/plugin.json` 과 `agents/`, `skills/`, `commands/`, `hooks/` 중 필요한 것을 둔다.
3. 루트 `.claude-plugin/marketplace.json` 의 `plugins` 배열에 새 plugin 엔트리 추가 (`name`, `description`, `source: "./plugins/<name>"`).
4. `git commit && git push`.
5. 다른 머신에서 `claude plugin install <name>@claude-code-plugin-pack` 으로 설치.

같은 마켓플레이스 안의 plugin 끼리는 독립적으로 install/uninstall/update 가 가능하다.

## 규칙 변경 원칙

룰에 대한 피드백을 받으면 로컬 메모리, `~/.claude/CLAUDE.md`, 개별 프로젝트 메모리에 저장하지 않고 이 repo 의 해당 `SKILL.md` 본문을 직접 수정한 뒤 커밋/푸시. 단일 원본 (single source of truth) 을 유지하기 위함.
