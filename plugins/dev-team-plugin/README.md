# dev-team-plugin

풀스택 개발을 위한 Claude Code 플러그인. 전문 에이전트와 슬래시 커맨드 스킬을 제공합니다.

## 구조

```
dev-team-plugin/
├── agents/       # 자율 에이전트 (Task 도구로 자동 호출)
├── skills/       # 슬래시 커맨드 스킬 (/skill-name)
└── .claude-plugin/plugin.json
```

## 에이전트 (11종)

| 에이전트 | 역할 |
|---------|------|
| react-fsd-developer | React/Next.js 프론트엔드 (FSD 아키텍처) |
| nestjs-backend-developer | NestJS 백엔드 (SOLID 원칙) |
| react-native-developer | React Native 모바일 앱 |
| tdd-test-engineer | 테스트 작성 및 TDD |
| project-setter | 모노레포 보일러플레이트 세팅 |
| devops-infra-architect | Docker, Nginx, CI/CD |
| pm-document-architect | PRD 및 요구사항 문서 |
| positive-code-reviewer | 긍정적 코드 리뷰 |
| negative-code-reviewer | 비판적 코드 리뷰 |
| final-reviewer | 최종 배포 판정 |
| tech-teacher-ko | 기술 개념 한국어 설명 |

## 스킬 (30종)

**Backend (NestJS)**
`/nest-crud` `/nest-auth` `/nest-dto` `/nest-guard` `/nest-prisma` `/nest-exception`

**Frontend (FSD)**
`/fsd-slice` `/fsd-page` `/fsd-form` `/fsd-query` `/fsd-widget`

**Mobile (React Native)**
`/rn-screen` `/rn-form` `/rn-platform` `/rn-list`

**Test**
`/test-unit` `/test-component` `/test-api` `/test-e2e`

**DevOps**
`/docker-file` `/docker-compose` `/nginx-conf` `/ci-cd`

**PM & Review**
`/prd` `/task-list` `/design-guide` `/review-good` `/review-bad` `/review-final` `/explain`

## 기술 스택

- **Frontend**: React, Next.js, TanStack Query, Tailwind CSS, react-hook-form, zod
- **Backend**: NestJS, Prisma, PostgreSQL, JWT
- **Mobile**: React Native, Expo
- **Infra**: Docker, Nginx, GitHub Actions
- **아키텍처**: FSD, SOLID, TDD
