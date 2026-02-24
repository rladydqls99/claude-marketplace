---
name: test-unit
description: Generate Jest unit tests using the AAA pattern (Arrange-Act-Assert). Trigger when asked to write unit tests for a function, class, service, or utility. Use for pure logic, business rules, helper functions, and isolated modules. Applies when the target has no UI and no HTTP layer.
---

# Test Unit

## Overview

Generates Jest unit tests with AAA structure, Korean descriptions, and coverage for edge cases (null, undefined, empty string, boundary values).

## Template

```ts
import { targetFunction } from '../path/to/module';

// Mock external dependencies at the top
jest.mock('../path/to/dependency', () => ({
  depMethod: jest.fn(),
}));

describe('targetFunction', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('정상적인 입력값으로 올바른 결과를 반환한다', () => {
    // Arrange
    const input = { value: 'valid' };

    // Act
    const result = targetFunction(input);

    // Assert
    expect(result).toEqual({ success: true });
  });

  it('null 입력값에 대해 에러를 던진다', () => {
    // Arrange
    const input = null;

    // Act & Assert
    expect(() => targetFunction(input)).toThrow('입력값이 필요합니다');
  });

  it('빈 문자열 입력값에 대해 기본값을 반환한다', () => {
    // Arrange
    const input = '';

    // Act
    const result = targetFunction(input);

    // Assert
    expect(result).toBe(defaultValue);
  });
});
```

## Rules

- `describe` block: module or function name
- `it` block: Korean description of the expected behavior
- `beforeEach`: always call `jest.clearAllMocks()`
- Mock all external deps (DB, HTTP, filesystem) at module level
- Cover: happy path, null, undefined, empty string, boundary values (0, -1, max)
- Use `jest.spyOn` for partial mocks, `jest.fn()` for full stubs
