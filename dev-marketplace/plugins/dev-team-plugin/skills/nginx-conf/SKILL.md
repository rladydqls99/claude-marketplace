---
name: nginx-conf
description: Generates Nginx reverse proxy configuration for full-stack deployments. Trigger when asked to create or update an nginx.conf, set up SSL/TLS termination, configure HTTP-to-HTTPS redirect, add security headers, rate limiting, or WebSocket proxying.
---

# Nginx Config

## Overview

Generates production-grade Nginx configuration with HTTP→HTTPS redirect, upstream blocks, SSL/TLS, gzip, security headers, API rate limiting, and WebSocket support.

## Full nginx.conf Template

```nginx
worker_processes auto;
events { worker_connections 1024; }

http {
  include       /etc/nginx/mime.types;
  default_type  application/octet-stream;
  sendfile      on;
  keepalive_timeout 65;

  # Gzip
  gzip on;
  gzip_types text/plain text/css application/json application/javascript text/xml application/xml image/svg+xml;
  gzip_min_length 1024;

  # Rate limiting
  limit_req_zone $binary_remote_addr zone=api_limit:10m rate=30r/m;

  # Upstreams
  upstream backend  { server backend:3000; }
  upstream frontend { server frontend:3000; }

  # HTTP → HTTPS redirect
  server {
    listen 80;
    server_name example.com www.example.com;
    return 301 https://$host$request_uri;
  }

  # HTTPS main server
  server {
    listen 443 ssl;
    http2 on;
    server_name example.com www.example.com;

    ssl_certificate     /etc/nginx/certs/fullchain.pem;
    ssl_certificate_key /etc/nginx/certs/privkey.pem;
    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers         HIGH:!aNULL:!MD5;
    ssl_session_cache   shared:SSL:10m;
    ssl_session_timeout 10m;

    # Security headers
    add_header X-Frame-Options        "SAMEORIGIN"            always;
    add_header X-XSS-Protection       "1; mode=block"         always;
    add_header X-Content-Type-Options "nosniff"               always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header Referrer-Policy        "strict-origin-when-cross-origin" always;

    # API proxy with rate limiting
    location /api/ {
      limit_req zone=api_limit burst=10 nodelay;
      proxy_pass         http://backend;
      proxy_http_version 1.1;
      proxy_set_header   Host              $host;
      proxy_set_header   X-Real-IP         $remote_addr;
      proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Proto $scheme;
    }

    # WebSocket support (e.g. /socket.io/)
    location /socket.io/ {
      proxy_pass         http://backend;
      proxy_http_version 1.1;
      proxy_set_header   Upgrade    $http_upgrade;
      proxy_set_header   Connection "upgrade";
      proxy_set_header   Host       $host;
    }

    # Frontend (catch-all)
    location / {
      proxy_pass         http://frontend;
      proxy_http_version 1.1;
      proxy_set_header   Host              $host;
      proxy_set_header   X-Real-IP         $remote_addr;
      proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
      proxy_set_header   X-Forwarded-Proto $scheme;
    }
  }
}
```

## Key Patterns

| Concern | Setting |
|---|---|
| HTTP redirect | `return 301 https://$host$request_uri` |
| TLS versions | `TLSv1.2 TLSv1.3` only |
| HSTS | `max-age=31536000; includeSubDomains` |
| Rate limit zone | `10m` shared memory, `30r/m` per IP |
| WebSocket | `Upgrade` + `Connection` headers required |
| Gzip min size | `1024` bytes — avoids compressing tiny payloads |

## Cert Paths (Let's Encrypt)

```nginx
ssl_certificate     /etc/nginx/certs/fullchain.pem;
ssl_certificate_key /etc/nginx/certs/privkey.pem;
```

Mount via Docker Compose volume: `./nginx/certs:/etc/nginx/certs:ro`

## Customization Points

- Replace `example.com` with actual domain.
- Adjust `rate=30r/m` and `burst=10` per API traffic expectations.
- Add `location /health { access_log off; return 200 "ok"; }` for load balancer probes.
