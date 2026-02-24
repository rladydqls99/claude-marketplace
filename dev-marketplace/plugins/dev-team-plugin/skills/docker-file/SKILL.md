---
name: docker-file
description: Generates production-ready multi-stage Dockerfiles for NestJS and Next.js services. Trigger when asked to create, write, or optimize a Dockerfile, containerize a service, or set up Docker image builds for backend/frontend Node.js applications.
---

# Dockerfile

## Overview

Generates optimized multi-stage Dockerfiles using Alpine/slim bases, non-root user execution, layer caching, and HEALTHCHECK. Supports NestJS (backend) and Next.js (frontend) service types.

## Decision Tree

- NestJS / backend API → use NestJS template
- Next.js / frontend SSR → use Next.js template
- Generic Node.js → adapt NestJS template, remove nest-specific steps

## NestJS Template

```dockerfile
# syntax=docker/dockerfile:1
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm ci
COPY . .
RUN npm run build

FROM node:20-alpine AS runner
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
USER appuser
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1
CMD ["node", "dist/main"]
```

## Next.js Template

```dockerfile
# syntax=docker/dockerfile:1
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci

FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:20-alpine AS runner
ENV NODE_ENV=production
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
USER appuser
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD wget -qO- http://localhost:3000/ || exit 1
CMD ["node", "server.js"]
```

## .dockerignore

Always create alongside Dockerfile:

```
node_modules
.next
dist
.git
*.log
.env*
!.env.example
coverage
.nyc_output
```

## Layer Caching Rules

1. Copy `package*.json` before source — keeps dependency layer cached across code changes.
2. Separate `npm ci --only=production` and full `npm ci` only if build tools differ from runtime deps.
3. In Next.js, use `output: 'standalone'` in `next.config.js` to enable slim runner stage.

## Security Rules

- Always create a non-root user (`adduser -S`) and switch with `USER`.
- Never embed secrets in the image; use runtime env vars.
- Use `node:20-alpine` (not `latest`) for reproducible builds.
