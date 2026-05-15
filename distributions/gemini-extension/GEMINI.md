# jihan-agents extension

Documentation-lifecycle role suite for Gemini CLI. Same source as the Claude Code `jihan-agents` plugin and the OpenCode bundle, adapted to Gemini's skill + command model.

## 수록 skill

| 이름 | 역할 | user-invokable |
| --- | --- | --- |
| `general-doc-rules` | 문서 작성 공통 규칙 | false (library, 다른 스킬이 활성화) |
| `method-doc-rules` | 단계별 방법 문서 작성 규칙 | false (library) |
| `notion-writer` | Notion 페이지 작성, 수정 전담 | true |
| `verifier-on-sandbox` | 문서 안의 셸 명령을 일회용 Ubuntu Docker 컨테이너에서 실행하고 pass/fail 보고 | true |
| `notion-doc-verifier` | Notion how-to 종합 검증 오케스트레이터, 인라인 코멘트로 피드백 | true |
| `notion-verifier-gui` | GUI lane, 공개 URL 가용성과 UI 라벨 확인 | false (internal lane) |
| `notion-verifier-concept` | Concept lane, 죽은 링크, 누락 단계, 사실 불일치 검토 | false (internal lane) |

## 사용

```text
/skills activate notion-doc-verifier
```

또는 평소 채팅에서 트리거 키워드를 쓰면 Gemini 가 자동으로 스킬을 선택.

오케스트레이터(`notion-doc-verifier`) 가 동작하면 내부적으로 `verifier-on-sandbox`, `notion-verifier-gui`, `notion-verifier-concept` 스킬을 순차 활성화해 lane 별 결과를 모으고, 마지막에 `mcp__notion__notion-create-comment` 로 인라인 피드백을 게시한다.

## Tool 이름 매핑 (Claude Code → Gemini CLI)

스킬 본문의 도구 이름은 Claude Code 기준으로 작성되어 있다. Gemini 에서 실행할 때는 다음 표를 참고해 등가 도구로 치환할 것.

| Claude Code | Gemini CLI |
| --- | --- |
| `Bash` | `run_shell_command` |
| `Read` | `read_file` |
| `Write` | `write_file` / `WriteFile` |
| `Edit` | `replace` |
| `Grep` | `grep_search` |
| `Glob` | `glob` |
| `LS` | `list_directory` |
| `WebFetch` | `web_fetch` (또는 동등 web 검색 도구) |
| `Agent` (sub-agent dispatch) | Gemini 의 sub-agent activation 메커니즘으로 치환. 단일 세션이면 inline 으로 직접 수행. |
| MCP 도구 (`mcp__notion__*`, `mcp__ghostdesk__*`) | 동일 이름. `~/.gemini/settings.json` 의 `mcpServers` 에 동일 서버를 등록할 것. |

## 외부 의존

- `notion-doc-verifier`, `notion-writer` 는 Notion MCP 서버 필요. Gemini CLI 설정에 다음 추가.
    ```json
    {
      "mcpServers": {
        "notion": {
          "command": "npx",
          "args": ["-y", "@notionhq/notion-mcp-server"]
        }
      }
    }
    ```
- `verifier-on-sandbox` 는 호스트에 `colima` + `docker` CLI 필요.
- `notion-verifier-gui` 는 ghostdesk 가상 데스크탑 MCP 또는 동등한 화면 캡처 도구 필요. ghostdesk 가 없으면 `WebFetch` (또는 `web_fetch`) 만으로 fallback 동작 (공개 URL 가용성만 확인).

## 의존 관계

`notion-doc-verifier` → `verifier-on-sandbox`, `notion-verifier-gui`, `notion-verifier-concept` (필수). 통합 익스텐션이므로 같이 설치되어 분리할 수 없다.

`notion-writer` → `general-doc-rules`, `method-doc-rules` (필수). 둘 다 같이 설치된다.
