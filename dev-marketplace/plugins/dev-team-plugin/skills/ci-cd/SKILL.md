---
name: ci-cd
description: Generates CI/CD pipeline scripts for containerized Node.js applications. Trigger when asked to create a deployment pipeline, GitHub Actions workflow, CI script, zero-downtime deploy, blue-green deployment, or automated rollback on failure.
---

# CI/CD Pipeline

## Overview

Generates CI/CD pipelines following the pattern: lint → build → test → docker build → push → DB migrate → deploy → healthcheck → rollback on failure. Supports GitHub Actions with zero-downtime deployment (blue-green or rolling).

## Pipeline Stages

```
lint → build → test → docker-build → push → migrate → deploy → healthcheck
                                                                      ↓ (fail)
                                                                   rollback
```

## GitHub Actions Workflow Template

```yaml
name: Deploy

on:
  push:
    branches: [main]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      - run: npm ci
      - run: npm run lint
      - run: npm run build
      - run: npm run test:ci

  docker-build-push:
    needs: lint-and-test
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    outputs:
      image_tag: ${{ steps.meta.outputs.tags }}
    steps:
      - uses: actions/checkout@v4
      - uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=sha,prefix=,format=short
            type=raw,value=latest,enable={{is_default_branch}}
      - uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  deploy:
    needs: docker-build-push
    runs-on: ubuntu-latest
    environment: production
    steps:
      - name: Deploy via SSH
        uses: appleboy/ssh-action@v1
        with:
          host: ${{ secrets.DEPLOY_HOST }}
          username: ${{ secrets.DEPLOY_USER }}
          key: ${{ secrets.DEPLOY_SSH_KEY }}
          script: |
            set -e
            IMAGE="${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}"

            # Pull new image
            docker pull "$IMAGE"

            # DB migration before traffic switch
            docker run --rm --env-file /app/.env "$IMAGE" npm run migration:run

            # Blue-green: start new container
            docker run -d --name backend_new \
              --env-file /app/.env \
              --network app-network \
              "$IMAGE"

            # Healthcheck new container
            for i in $(seq 1 12); do
              if docker exec backend_new wget -qO- http://localhost:3000/health; then
                echo "New container healthy"
                break
              fi
              [ "$i" -eq 12 ] && { echo "Healthcheck failed — rolling back"; docker rm -f backend_new; exit 1; }
              sleep 5
            done

            # Swap: remove old, rename new
            docker rm -f backend_old 2>/dev/null || true
            docker rename backend backend_old 2>/dev/null || true
            docker rename backend_new backend

            # Reload nginx upstream (zero-downtime)
            docker exec nginx nginx -s reload

            # Cleanup old container after confirm
            sleep 10
            docker rm -f backend_old 2>/dev/null || true
```

## Rollback Script

Keep on the server at `/app/rollback.sh`:

```bash
#!/bin/bash
set -e
echo "Rolling back to previous image..."
docker stop backend && docker rm backend
docker rename backend_old backend
docker exec nginx nginx -s reload
echo "Rollback complete."
```

## Key Rules

- DB migrations run BEFORE traffic switches to new container.
- Healthcheck retries 12 times (60s window) before triggering rollback.
- Old container is renamed `backend_old` and kept for 10 seconds as fast rollback target.
- Use `cache-from: type=gha` in `docker/build-push-action` to reuse layer cache across runs.
- Store `DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_SSH_KEY` as GitHub Actions secrets.
- Tag images with `github.sha` (short) for immutable, traceable deployments.
