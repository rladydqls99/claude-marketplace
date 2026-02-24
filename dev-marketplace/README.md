# Dev Marketplace

풀스택 개발을 위한 Claude Code 마켓플레이스. 13종 AI 에이전트 + 30종 슬래시 커맨드 스킬을 제공합니다.

## 설치

```bash
# 1. 클론
git clone https://github.com/rladydqls99/claude-marketplace.git

# 2. 마켓플레이스 설치
claude install-marketplace ./claude-marketplace/dev-marketplace
```

설치 후 Claude Code에서 에이전트는 자동 호출되고, 스킬은 `/스킬이름`으로 사용합니다.

## 기술 스택

| 영역 | 기술 |
|------|------|
| **Frontend** | React, Next.js, TanStack Query, Tailwind CSS, react-hook-form, zod, ky |
| **Backend** | NestJS, Prisma, PostgreSQL, JWT, class-validator |
| **Mobile** | React Native, Expo |
| **Infra** | Docker, Nginx, GitHub Actions |
| **아키텍처** | FSD, SOLID, TDD, Turborepo + pnpm |

## 삭제

```bash
claude uninstall-marketplace dev-market-place
```
