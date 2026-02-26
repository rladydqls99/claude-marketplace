# Frontend Develop Plugin

React 기반 FSD 아키텍처 프론트엔드 개발을 위한 종합 플러그인입니다.
Next.js, TanStack Start, Vite, CRA 등 React를 사용하는 모든 프로젝트에 적용 가능합니다.
기획 분석부터 코드 작성, 코드 리뷰까지 전체 개발 워크플로우를 커버합니다.

---

## 에이전트

### 🟣 frontend-planner
기획 문서를 분석해 화면 구성, 태스크 목록, 우선순위를 도출합니다.
사소한 요구사항(로딩 상태, 빈 상태, 에러 상태)도 빠짐없이 분석합니다.

**사용 스킬**: `screen-analysis`, `task-breakdown`, `priority-matrix`

### 🔵 frontend-developer
FSD 아키텍처 기반 React 개발자 에이전트입니다. (Next.js / TanStack Start / Vite / CRA 등 지원)
62개 코딩 규칙을 적용하고, global.css 기반으로 독창적인 UI를 구현합니다.

**사용 스킬**: `frontend-rules`, `frontend-design`

### 🟢 positive-reviewer
코드의 강점과 모범 사례를 발굴합니다.
구체적인 근거와 코드 발췌를 함께 제시합니다.

**사용 스킬**: `review-positive`

### 🔴 negative-reviewer
코드의 버그, 성능 이슈, 안티패턴을 Critical/Major/Minor로 분류합니다.
모든 문제에 수정 코드를 함께 제시합니다.

**사용 스킬**: `review-negative`

### 🟡 final-reviewer
긍정/부정 리뷰를 종합해 최종 머지 판정을 내립니다.
Approve / Approve with Suggestions / Request Changes / Reject 중 하나를 선택합니다.

**사용 스킬**: `review-final`

---

## 스킬

| 스킬 | 설명 |
|------|------|
| `frontend-design` | 독창적인 UI 디자인 (global.css 자동 감지 + 색상 기반 구성) |
| `frontend-rules` | 62개 코딩 규칙 적용 가이드 (상황별 규칙 매핑 포함) |
| `screen-analysis` | 기획서 → 화면 목록 + 컴포넌트 구조 + 상태 도출 |
| `task-breakdown` | 기능/화면 → FE 개발 태스크 분해 (FSD 레이어 기준) |
| `priority-matrix` | 태스크 → P0/P1/P2 우선순위 분류 + 개발 순서 제안 |
| `review-positive` | 코드 강점 분석 (아키텍처/성능/품질/UX) |
| `review-negative` | 코드 문제점 분석 (버그/성능/안티패턴) |
| `review-final` | 최종 판정 + 즉시 처리/백로그 목록 |

---

## 권장 워크플로우

### 신규 기능 개발
```
frontend-planner → frontend-developer → (positive + negative reviewer 병렬) → final-reviewer
```

### 코드 리뷰만
```
positive-reviewer + negative-reviewer (병렬) → final-reviewer
```

### 기획만
```
frontend-planner (screen-analysis → task-breakdown → priority-matrix)
```

---

## 코딩 규칙 카테고리 (62개)

- `async-*` (5개): 비동기 처리, Promise.all, Suspense
- `bundle-*` (5개): 동적 import, 배럴 최적화, 프리로드
- `client-*` (4개): 이벤트 리스너, LocalStorage, SWR
- `custom-*` (10개): FSD 패턴, 폼 핸들링, API 통합
- `js-*` (12개): JS 성능 최적화, Map/Set, 이터레이션
- `rendering-*` (8개): 렌더링 최적화, SVG, 하이드레이션
- `rerender-*` (9개): 리렌더링 방지, memo, 파생 상태
- `server-*` (7개): 서버 사이드 처리, 캐싱, 서버 함수 (Next.js / TanStack Start 등 SSR 프레임워크 사용 시 적용)
- `advanced-*` (2개): 고급 refs 패턴, useLatest
