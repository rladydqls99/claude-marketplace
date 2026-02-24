---
name: docker-compose
description: Generates Docker Compose configuration for full-stack deployments. Trigger when asked to create or update a docker-compose.yml, orchestrate multiple services (db, backend, frontend, nginx), or set up local/production container environments.
---

# Docker Compose

## Overview

Generates Docker Compose files with service health checks, network separation, named volumes, and environment variable loading from `.env`. Covers the standard stack: PostgreSQL, NestJS backend, Next.js frontend, and Nginx reverse proxy.

## Full-Stack Template

```yaml
version: "3.9"

services:
  db:
    image: postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${DB_NAME}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - backend-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER} -d ${DB_NAME}"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    restart: unless-stopped
    env_file: .env
    environment:
      DATABASE_URL: postgresql://${DB_USER}:${DB_PASSWORD}@db:5432/${DB_NAME}
    depends_on:
      db:
        condition: service_healthy
    networks:
      - backend-network
    healthcheck:
      test: ["CMD-SHELL", "wget -qO- http://localhost:3000/health || exit 1"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 15s

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    restart: unless-stopped
    env_file: .env
    depends_on:
      backend:
        condition: service_healthy
    networks:
      - frontend-network
    healthcheck:
      test: ["CMD-SHELL", "wget -qO- http://localhost:3000/ || exit 1"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 20s

  nginx:
    image: nginx:1.25-alpine
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/certs:/etc/nginx/certs:ro
    depends_on:
      backend:
        condition: service_healthy
      frontend:
        condition: service_healthy
    networks:
      - backend-network
      - frontend-network

volumes:
  db-data:

networks:
  backend-network:
    driver: bridge
  frontend-network:
    driver: bridge
```

## Network Separation Rules

- `backend-network`: db + backend + nginx
- `frontend-network`: frontend + nginx
- db must NOT be on `frontend-network` — never expose db to frontend directly

## .env Reference

```env
DB_NAME=haru
DB_USER=haru_user
DB_PASSWORD=strong_password_here
```

## Common Variations

**Add Redis cache:**
```yaml
  redis:
    image: redis:7-alpine
    restart: unless-stopped
    networks:
      - backend-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 3
```

**Override for local dev** (`docker-compose.override.yml`):
```yaml
services:
  backend:
    volumes:
      - ./backend:/app
    command: npm run start:dev
```
