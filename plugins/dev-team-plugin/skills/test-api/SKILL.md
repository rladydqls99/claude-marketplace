---
name: test-api
description: Generate Supertest API integration tests for Express/NestJS routes. Trigger when asked to write tests for an HTTP endpoint, REST API, or route handler. Use when the test involves an actual HTTP request/response cycle, request body validation, status codes, or auth middleware.
---

# Test API

## Overview

Generates Supertest integration tests with DB seed/teardown, auth token setup, and full request-response assertion.

## Template

```ts
import request from 'supertest';
import { app } from '../app';
import { db } from '../db';

describe('POST /api/resource', () => {
  let authToken: string;

  beforeAll(async () => {
    // Seed auth user and get token
    await db.user.create({ data: { email: 'test@example.com', password: 'hashed' } });
    const res = await request(app)
      .post('/api/auth/login')
      .send({ email: 'test@example.com', password: 'password' });
    authToken = res.body.token;
  });

  beforeEach(async () => {
    // Clean up resource table before each test
    await db.resource.deleteMany();
  });

  afterAll(async () => {
    await db.user.deleteMany();
    await db.$disconnect();
  });

  it('유효한 요청으로 리소스를 생성하고 201을 반환한다', async () => {
    const payload = { name: '테스트 리소스', amount: 100 };

    const res = await request(app)
      .post('/api/resource')
      .set('Authorization', `Bearer ${authToken}`)
      .send(payload)
      .expect(201);

    expect(res.body).toMatchObject({ name: '테스트 리소스', amount: 100 });
    expect(res.body.id).toBeDefined();
  });

  it('인증 토큰 없이 요청하면 401을 반환한다', async () => {
    await request(app).post('/api/resource').send({ name: 'x' }).expect(401);
  });

  it('필수 필드 누락 시 400을 반환한다', async () => {
    const res = await request(app)
      .post('/api/resource')
      .set('Authorization', `Bearer ${authToken}`)
      .send({})
      .expect(400);

    expect(res.body.message).toBeDefined();
  });
});
```

## Rules

- `describe` block: `METHOD /api/path` format
- `beforeAll`: seed DB and acquire auth token
- `beforeEach`: delete target table rows (not full DB wipe)
- `afterAll`: cleanup all seeded data and disconnect
- Assert both status code (`.expect(status)`) and response body
- Cover: success, 401 unauthorized, 400 bad request, 404 not found
