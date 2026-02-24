---
name: test-component
description: Generate React Testing Library (RTL) component tests. Trigger when asked to write tests for a React component, UI element, form, modal, or hook. Use accessibility-first queries (getByRole, getByText) and userEvent for interaction. Apply when the target is a .tsx/.jsx file rendering UI.
---

# Test Component

## Overview

Generates RTL component tests with accessibility-first queries, userEvent interactions, Korean descriptions, and async handling via `act()`.

## Template

```tsx
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { TargetComponent } from '../TargetComponent';

// Mock external dependencies
jest.mock('../hooks/useApi', () => ({
  useApi: jest.fn(() => ({ data: null, loading: false, error: null })),
}));

describe('TargetComponent', () => {
  const defaultProps = {
    onSubmit: jest.fn(),
    label: '제출',
  };

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('기본 상태에서 버튼이 렌더링된다', () => {
    render(<TargetComponent {...defaultProps} />);

    expect(screen.getByRole('button', { name: '제출' })).toBeInTheDocument();
  });

  it('입력 후 제출 버튼을 클릭하면 onSubmit이 호출된다', async () => {
    const user = userEvent.setup();
    render(<TargetComponent {...defaultProps} />);

    await user.type(screen.getByRole('textbox', { name: /이름/i }), '홍길동');
    await user.click(screen.getByRole('button', { name: '제출' }));

    expect(defaultProps.onSubmit).toHaveBeenCalledWith({ name: '홍길동' });
  });

  it('로딩 중에는 버튼이 비활성화된다', async () => {
    render(<TargetComponent {...defaultProps} loading />);

    await waitFor(() => {
      expect(screen.getByRole('button', { name: '제출' })).toBeDisabled();
    });
  });

  it('에러 메시지가 화면에 표시된다', () => {
    render(<TargetComponent {...defaultProps} error="오류가 발생했습니다" />);

    expect(screen.getByText('오류가 발생했습니다')).toBeInTheDocument();
  });
});
```

## Rules

- Query priority: `getByRole` > `getByLabelText` > `getByText` > `getByTestId`
- Use `userEvent.setup()` + `await user.click/type` instead of `fireEvent`
- Wrap async state updates in `waitFor` or `await user.*`
- Use `act()` only when no RTL async helper covers the case
- `it` descriptions in Korean explaining the expected UI behavior
- Mock hooks and context providers at module level
