---
name: frontend-rules
description: Apply frontend coding rules and best practices for React-based development (Next.js, TanStack Start, Vite, CRA, etc.). Use this skill whenever writing or reviewing frontend code — component creation, hooks, async data fetching, performance optimization, rendering patterns, state management, or FSD architecture. Automatically select and apply the relevant rule(s) from the rules/ directory based on context. ALWAYS reference this skill during any frontend code generation task.
---

# Frontend Rules Skill

이 스킬은 `rules/` 폴더의 62개 규칙을 상황에 맞게 선택·적용하는 가이드다.
코드를 작성하거나 리뷰할 때 아래 매핑을 참고해 **가장 관련 있는 규칙 파일**을 읽고 적용한다.

---

## 규칙 카테고리별 사용 상황

### 🔄 비동기 처리 (`async-*`)
**사용 상황**: API 호출, 데이터 패칭, 비동기 함수 작성 시

| 파일 | 적용 상황 |
|------|----------|
| `async-parallel.md` | 독립적인 API 호출이 여러 개일 때 → `Promise.all()` 패턴 |
| `async-defer-await.md` | await 순서 최적화, 불필요한 직렬 실행 제거 시 |
| `async-api-routes.md` | API 라우트 또는 서버 핸들러 작성 시 (프레임워크 무관) |
| `async-dependencies.md` | 비동기 의존성 체인 설계 시 |
| `async-suspense-boundaries.md` | React Suspense와 비동기 데이터 패칭 연동 시 |

---

### 📦 번들링 최적화 (`bundle-*`)
**사용 상황**: 빌드 성능, 초기 로딩 속도 개선, 코드 스플리팅 작업 시

| 파일 | 적용 상황 |
|------|----------|
| `bundle-dynamic-imports.md` | 컴포넌트/라이브러리 동적 import(`React.lazy`, `next/dynamic`) 적용 시 |
| `bundle-barrel-imports.md` | `index.ts` 배럴 파일로 인한 번들 크기 증가 문제 해결 시 |
| `bundle-preload.md` | 중요 리소스 사전 로딩(`<link rel="preload">`) 설계 시 |
| `bundle-conditional.md` | 조건부 모듈 로딩 패턴 적용 시 |
| `bundle-defer-third-party.md` | 서드파티 스크립트(analytics, 챗봇 등) 지연 로딩 시 |

---

### 💻 클라이언트 사이드 처리 (`client-*`)
**사용 상황**: 브라우저 API, 이벤트 리스너, 로컬 스토리지 사용 시

| 파일 | 적용 상황 |
|------|----------|
| `client-event-listeners.md` | 이벤트 리스너 등록/해제 패턴 설계 시 |
| `client-passive-event-listeners.md` | 스크롤, 터치 이벤트 성능 최적화 시 |
| `client-localstorage-schema.md` | LocalStorage 데이터 구조 설계 시 |
| `client-swr-dedup.md` | SWR 또는 TanStack Query 중복 요청 제거 시 |

---

### 🏗️ 아키텍처 패턴 (`custom-*`)
**사용 상황**: FSD 레이어 구조 설계, 컴포넌트/훅 패턴 정의 시

| 파일 | 적용 상황 |
|------|----------|
| `custom-feature-pattern.md` | FSD `features/` 레이어 슬라이스 생성 시 |
| `custom-entity-pattern.md` | FSD `entities/` 레이어 슬라이스 생성 시 |
| `custom-page-pattern.md` | FSD `pages/` 레이어 페이지 컴포넌트 작성 시 |
| `custom-widget-pattern.md` | FSD `widgets/` 레이어 위젯 컴포넌트 작성 시 |
| `custom-form-handling.md` | `react-hook-form` + `zod` 폼 컴포넌트 작성 시 |
| `custom-api-integration.md` | API 클라이언트(`ky` 등) 통합 레이어 설계 시 |
| `custom-import-organization.md` | import 구문 정렬 및 경로 별칭 설정 시 |
| `custom-arrow-functions.md` | 함수 선언 스타일(화살표 함수 강제) 적용 시 |
| `custom-props-naming.md` | Props 타입 네이밍 컨벤션 적용 시 |
| `custom-anti-patterns.md` | 흔한 안티패턴 감지 및 수정 시 |

---

### ⚡ JS 성능 최적화 (`js-*`)
**사용 상황**: 루프, 데이터 변환, 캐싱, 알고리즘 최적화 시

| 파일 | 적용 상황 |
|------|----------|
| `js-cache-function-results.md` | 반복 호출되는 함수 결과 메모이제이션 시 |
| `js-cache-property-access.md` | 반복적인 객체 프로퍼티 접근 최적화 시 |
| `js-cache-storage.md` | 브라우저 캐시 저장소 활용 패턴 시 |
| `js-index-maps.md` | 배열 → Map/객체 인덱스로 O(n)→O(1) 검색 최적화 시 |
| `js-set-map-lookups.md` | Set/Map을 활용한 중복 제거, 빠른 조회 시 |
| `js-combine-iterations.md` | 여러 배열 순회를 하나로 합칠 때 |
| `js-early-exit.md` | 조건 검사를 앞으로 당겨 불필요한 연산 제거 시 |
| `js-length-check-first.md` | 빈 배열 조기 반환 패턴 적용 시 |
| `js-min-max-loop.md` | 최솟값/최댓값 루프 최적화 시 |
| `js-hoist-regexp.md` | 정규식을 루프 밖으로 호이스팅 시 |
| `js-batch-dom-css.md` | DOM/CSS 배치 읽기-쓰기 최적화 시 |
| `js-tosorted-immutable.md` | 불변 정렬(`toSorted`) 패턴 적용 시 |

---

### 🖼️ 렌더링 최적화 (`rendering-*`)
**사용 상황**: 화면 렌더링 성능, 페인트 최적화, SVG, 하이드레이션 처리 시

| 파일 | 적용 상황 |
|------|----------|
| `rendering-hoist-jsx.md` | 렌더마다 새로 생성되는 JSX를 컴포넌트 밖으로 호이스팅 시 |
| `rendering-conditional-render.md` | 조건부 렌더링 최적화 패턴 적용 시 |
| `rendering-content-visibility.md` | `content-visibility: auto`로 오프스크린 요소 렌더링 지연 시 |
| `rendering-activity.md` | Activity API 또는 `visibility: hidden` 패턴으로 DOM 유지 시 |
| `rendering-usetransition-loading.md` | `useTransition`으로 로딩 상태 우선순위 조정 시 |
| `rendering-hydration-no-flicker.md` | SSR/하이드레이션 플리커 제거 시 (SSR 지원 프레임워크 사용 시) |
| `rendering-svg-precision.md` | SVG 좌표 정밀도 최적화 시 |
| `rendering-animate-svg-wrapper.md` | SVG 애니메이션 wrapper 패턴 적용 시 |

---

### 🔁 리렌더링 최적화 (`rerender-*`)
**사용 상황**: 불필요한 리렌더링 제거, `memo`, `useMemo`, `useCallback` 적용 시

| 파일 | 적용 상황 |
|------|----------|
| `rerender-memo.md` | `React.memo`로 컴포넌트 메모이제이션 시 |
| `rerender-memo-with-default-value.md` | memo 컴포넌트에 기본값 설정 패턴 적용 시 |
| `rerender-simple-expression-in-memo.md` | memo 내 단순 표현식 최적화 시 |
| `rerender-derived-state.md` | state 대신 파생 값 계산으로 불필요한 상태 제거 시 |
| `rerender-functional-setstate.md` | setState에 함수형 업데이터 적용 시 |
| `rerender-lazy-state-init.md` | useState 초기값 함수(`() => ...`) 사용 시 |
| `rerender-dependencies.md` | useEffect/useMemo/useCallback 의존성 배열 최적화 시 |
| `rerender-defer-reads.md` | 렌더 중 DOM 읽기 지연 패턴 적용 시 |
| `rerender-transitions.md` | `useTransition`으로 리렌더링 우선순위 분리 시 |

---

### 🖥️ 서버 사이드 처리 (`server-*`)
**사용 상황**: 서버 사이드 렌더링, 서버 함수, 서버 캐싱 설계 시 (Next.js, TanStack Start, Remix 등 SSR 지원 프레임워크 사용 시 적용)

| 파일 | 적용 상황 |
|------|----------|
| `server-parallel-fetching.md` | 서버 사이드에서 병렬 데이터 패칭 시 |
| `server-cache-react.md` | React `cache()` 함수로 서버 요청 중복 제거 시 |
| `server-cache-lru.md` | LRU 캐시로 서버 사이드 캐싱 구현 시 |
| `server-dedup-props.md` | 서버→클라이언트 props 중복 전달 제거 시 |
| `server-serialization.md` | 서버 데이터 직렬화 최적화 시 |
| `server-auth-actions.md` | 서버 함수에서 인증/인가 처리 시 |
| `server-after-nonblocking.md` | 논블로킹 후처리 작업 패턴 시 |

---

### 🔬 고급 패턴 (`advanced-*`)
**사용 상황**: 이벤트 핸들러 최신 값 참조, refs 활용 고급 패턴 적용 시

| 파일 | 적용 상황 |
|------|----------|
| `advanced-event-handler-refs.md` | 클로저 stale 문제 해결, 핸들러에서 최신 값 참조 시 |
| `advanced-use-latest.md` | `useLatest` 커스텀 훅 패턴 적용 시 |

---

## 적용 방법

1. 작업 유형을 파악한다 (비동기 처리? 성능 최적화? 렌더링?)
2. 해당 카테고리의 규칙 파일을 읽는다
3. Bad 예시 → Good 예시 패턴을 코드에 적용한다
4. 여러 규칙이 동시에 해당하면 모두 적용한다

## 작성 원칙

- 규칙은 강제 사항이다 — 선택적으로 무시하지 않는다
- 기존 코드와 충돌할 경우 팀 컨벤션을 우선하되 이유를 명시한다
- 모든 출력은 한국어로 설명하고, 코드는 영어로 작성한다
