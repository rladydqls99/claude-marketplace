---
name: test-e2e
description: Generate Playwright E2E tests using the Page Object Model (POM). Trigger when asked to write end-to-end tests, browser tests, or full user-flow tests. Use when the test covers a complete business flow (login → action → result) across real pages. Apply for critical paths: auth, checkout, form submission, navigation.
---

# Test E2E

## Overview

Generates Playwright E2E tests with Page Object Model classes, `data-testid` selectors, Korean descriptions, and `waitFor` for async flows.

## Page Object Template

```ts
// pages/ResourcePage.ts
import { Page, Locator } from '@playwright/test';

export class ResourcePage {
  readonly page: Page;
  readonly nameInput: Locator;
  readonly submitButton: Locator;
  readonly successMessage: Locator;

  constructor(page: Page) {
    this.page = page;
    this.nameInput = page.getByTestId('resource-name-input');
    this.submitButton = page.getByTestId('resource-submit-button');
    this.successMessage = page.getByTestId('success-message');
  }

  async navigate() {
    await this.page.goto('/resource/new');
  }

  async createResource(name: string) {
    await this.nameInput.fill(name);
    await this.submitButton.click();
  }

  async waitForSuccess() {
    await this.successMessage.waitFor({ state: 'visible' });
  }
}
```

## Test Template

```ts
// tests/resource.spec.ts
import { test, expect } from '@playwright/test';
import { ResourcePage } from '../pages/ResourcePage';
import { LoginPage } from '../pages/LoginPage';

test.describe('리소스 관리', () => {
  test.beforeEach(async ({ page }) => {
    const loginPage = new LoginPage(page);
    await loginPage.navigate();
    await loginPage.login('test@example.com', 'password');
  });

  test('새 리소스를 생성하면 목록에 표시된다', async ({ page }) => {
    const resourcePage = new ResourcePage(page);
    await resourcePage.navigate();

    await resourcePage.createResource('테스트 리소스');
    await resourcePage.waitForSuccess();

    await expect(page.getByTestId('success-message')).toContainText('생성되었습니다');
    await expect(page.getByTestId('resource-list')).toContainText('테스트 리소스');
  });

  test('필수 필드 없이 제출하면 유효성 오류가 표시된다', async ({ page }) => {
    const resourcePage = new ResourcePage(page);
    await resourcePage.navigate();

    await resourcePage.submitButton.click();

    await expect(page.getByTestId('field-error-name')).toBeVisible();
  });
});
```

## Rules

- One `PageObject` class per page: locators as class fields, actions as methods
- Selectors: prefer `data-testid` > `getByRole` > `getByText`
- `test.beforeEach`: handle auth/login setup
- Use `waitFor({ state: 'visible' })` and `expect(...).toBeVisible()` for async
- `test.describe` and `test` descriptions in Korean
- Cover the main business flow end-to-end, plus one failure/validation path
