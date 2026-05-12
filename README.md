# agent-doc-rules

Claude Code 플러그인. AI 에이전트가 문서, 가이드, 방법 문서를 작성할 때 따르는 규칙과 전담 writer 에이전트를 묶어 배포.

## 구성

- `skills/general-doc-rules/SKILL.md` — 모든 산출물 공통 규칙 (문체, 길이/구조, 사전 조사, 일반화, 코멘트)
- `skills/method-doc-rules/SKILL.md` — 단계별 실행 가이드 (`# 개요`, `# 준비`, `# 실행`, `# 확인` 4-섹션 구조, `**✅ Output**` 컨벤션, 콜아웃 색상 등)
- `agents/writer.md` — 두 skill 을 적용해 문서를 작성하는 전담 에이전트

## 설치

```bash
claude plugin marketplace add https://github.com/<your-org>/agent-doc-rules
claude plugin install agent-doc-rules@agent-doc-rules
```

로컬 개발 중에는 GitHub 없이 디렉터리 경로로도 설치 가능.

```bash
claude plugin marketplace add ~/agent-doc-rules
claude plugin install agent-doc-rules@agent-doc-rules
```

설치 확인.

```bash
claude plugin list
```

## 업데이트 흐름

1. 로컬에서 룰 또는 에이전트 정의 편집.

    ```bash
    $EDITOR ~/agent-doc-rules/skills/method-doc-rules/SKILL.md
    ```
2. 변경 사항 커밋 후 푸시.

    ```bash
    cd ~/agent-doc-rules
    git add -A
    git commit -m "rule: ..."
    git push
    ```
3. 다른 머신에서 최신 룰 반영.

    ```bash
    claude plugin update agent-doc-rules
    ```

## 사용

- 문서 작성 요청을 받으면 Claude 가 `general-doc-rules` skill 을 자동으로 적용한다.
- 단계별 실행 가이드, 설치/설정/테스트 절차를 요청하면 추가로 `method-doc-rules` skill 이 함께 적용된다.
- 전담 에이전트가 필요하면 `writer` 에이전트를 호출.

## 규칙 변경 원칙

룰에 대한 피드백을 받으면 로컬 메모리, `~/.claude/CLAUDE.md`, 개별 프로젝트 메모리에 저장하지 않고 이 repo 의 해당 `SKILL.md` 본문을 직접 수정한 뒤 커밋/푸시. 단일 원본 (single source of truth) 을 유지하기 위함.
