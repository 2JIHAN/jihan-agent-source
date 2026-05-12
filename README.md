# claude-code-plugin-pack

개인용 Claude Code 플러그인 팩. 룰, 에이전트, 스킬, 훅을 하나의 repo 에서 관리하고 다른 머신에서 한 줄로 받아쓰기 위한 단일 마켓플레이스 + 플러그인 구조. 현재 문서 작성 규칙과 writer 에이전트가 들어있고, 새 카테고리는 sub-skill / sub-agent 로 계속 추가한다.

## 구성

- `skills/general-doc-rules/SKILL.md` — 모든 산출물 공통 규칙 (문체, 길이/구조, 사전 조사, 일반화, 코멘트)
- `skills/method-doc-rules/SKILL.md` — 단계별 실행 가이드 (`# 개요`, `# 준비`, `# 실행`, `# 확인` 4-섹션 구조, `**✅ Output**` 컨벤션, 콜아웃 색상 등)
- `agents/writer.md` — 두 skill 을 적용해 문서를 작성하는 전담 에이전트

## 설치

```bash
claude plugin marketplace add https://github.com/2JIHAN/claude-code-plugin-pack
claude plugin install claude-code-plugin-pack@claude-code-plugin-pack
```

로컬 개발 중에는 GitHub 없이 디렉터리 경로로도 설치 가능.

```bash
claude plugin marketplace add ~/claude-code-plugin-pack
claude plugin install claude-code-plugin-pack@claude-code-plugin-pack
```

설치 확인.

```bash
claude plugin list
```

## 업데이트 흐름

1. 로컬에서 룰 또는 에이전트 정의 편집.

    ```bash
    $EDITOR ~/claude-code-plugin-pack/skills/method-doc-rules/SKILL.md
    ```
2. 변경 사항 커밋 후 푸시.

    ```bash
    cd ~/claude-code-plugin-pack
    git add -A
    git commit -m "rule: ..."
    git push
    ```
3. 다른 머신에서 최신 룰 반영.

    ```bash
    claude plugin update claude-code-plugin-pack
    ```

## 사용

- 문서 작성 요청을 받으면 Claude 가 `general-doc-rules` skill 을 자동으로 적용한다.
- 단계별 실행 가이드, 설치/설정/테스트 절차를 요청하면 추가로 `method-doc-rules` skill 이 함께 적용된다.
- 전담 에이전트가 필요하면 `writer` 에이전트를 호출.

## 확장

새 룰 카테고리, 에이전트, 훅을 추가하려면 다음 디렉터리 컨벤션을 따른다.

- `skills/<skill-name>/SKILL.md` — 모델이 description 기반으로 자동 활성화하는 룰/지침
- `agents/<agent-name>.md` — 명시적으로 spawn 되는 전담 에이전트
- `commands/<command>.md` — `/command` 슬래시 명령 (legacy 포맷)
- `hooks/` — SessionStart 등 라이프사이클 훅

추가 후 `git push` → 다른 머신에서 `claude plugin update claude-code-plugin-pack` 만 하면 반영.

## 규칙 변경 원칙

룰에 대한 피드백을 받으면 로컬 메모리, `~/.claude/CLAUDE.md`, 개별 프로젝트 메모리에 저장하지 않고 이 repo 의 해당 `SKILL.md` 본문을 직접 수정한 뒤 커밋/푸시. 단일 원본 (single source of truth) 을 유지하기 위함.
