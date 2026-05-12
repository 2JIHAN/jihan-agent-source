---
name: general-doc-rules
description: Use ONLY when the user explicitly asks to author/draft/write/save a DOCUMENT as an artifact (Notion page, markdown file, doc, report, guide file). The request must contain an explicit writing/saving verb together with a document noun. Trigger examples - "노션에 문서 써줘", "리포트 작성해줘", "이거 문서로 정리해줘", "write a doc", "draft a report", "save this as a markdown file". DO NOT trigger on regular chat answers, explanations, summaries, or "structured" inline responses, even if the reply ends up being long or formatted. When in doubt, do NOT load this skill.
version: 0.1.0
---

# 문서 작성 규칙 (general)

AI 에이전트가 문서, 답변, 산출물을 작성할 때 따르는 공통 규칙. 카테고리별 sub-skill 이 더 세부 규칙을 가질 수 있다 (예 `method-doc-rules`).

## 문체

- 콜론 (`:`) 은 레이블/필드명 뒤에만 쓴다 (예 `성공 기준:`, `Sources:`). 문장이나 구의 끝, 도입구에는 콜론 대신 공백 또는 쉼표를 쓴다 (예 "정리하면,").
- 인라인 나열에는 가운뎃점 (`·`, `•`) 대신 쉼표를 쓴다 (예 "A, B, C").
- 응답 언어는 사용자가 지정한 언어를 기본으로 하되, 기술 용어는 영어 병기를 허용한다.

## 길이와 구조

- 단순한 질문에는 단순한 답을 준다. 헤더/섹션은 정보량이 그것을 정당화할 때만 쓴다.
- 결과와 결정을 먼저, 부연은 뒤에. 사고 과정을 그대로 나열하지 않는다.
- 코드, 명령, 식별자는 인라인 백틱 또는 코드블록으로 감싼다.

## 사전 조사

- 문서, 산출물을 작성하기 전에 관련 토픽을 웹서치해 표준 방식, 최신 표기, 흔한 함정을 확인한 뒤 작성한다. 추측이 아닌 검증된 정보가 들어가도록 한다.
- 해당 도메인, 보드, 라이브러리의 공식 문서나 신뢰할 만한 튜토리얼을 우선해서 참조한다.
- 참조한 출처는 사용자 응답의 `Sources` 섹션에 markdown 링크로 남긴다.

## 방법 문서

단계별 실행 가이드, 설치법, 설정법, 테스트 절차처럼 사용자가 따라 하며 결과를 확인하는 문서는 `method-doc-rules` skill 의 세부 규칙을 따른다. 기본 문체와 일반 산출물 원칙은 이 문서의 공통 규칙을 그대로 따른다.

## 일반화

- 산출물은 다른 사람이 그대로 받아 쓸 수 있는 형태로 작성한다.
- 개인 종속 값 (개인 ID, 개인 토큰, 사용자별 절대 경로 등) 을 본문에 박지 않는다.
- 사용자별로 달라지는 값은 환경변수, 별도 설정 파일, 또는 이름 기반 검색으로 동적으로 찾도록 한다.
- 룰을 쓸 때도 "내가 쓸 것" 이 아니라 "이 룰을 받는 사람이 자기 환경에서 그대로 쓸 것" 시점으로 작성한다.

## 코멘트와 주석

- 코드를 설명하려고 코멘트를 쓰지 않는다. 잘 지은 식별자가 무엇을 하는지 이미 말한다.
- 코멘트는 왜 (Why) 가 비명백한 곳에만 쓴다 (숨은 제약, 미묘한 invariant, 특정 버그 우회, 직관과 다른 동작).
- 현재 작업, 호출자, 이슈 번호 같은 시점 종속 정보는 코멘트가 아니라 PR 설명, 커밋 메시지에 둔다.

## 규칙 업데이트

사용자가 이 규칙에 대한 피드백을 줄 때, 변경 사항은 이 SKILL.md 파일을 직접 update 한 뒤 `git commit && git push` 한다. 다른 머신에서는 `claude plugin update claude-code-plugin-pack` 로 반영. 로컬 메모리, 에이전트 메모리, CLAUDE.md 에 저장하지 않는다.
