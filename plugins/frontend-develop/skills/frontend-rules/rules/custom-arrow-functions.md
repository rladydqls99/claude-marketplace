## Use Arrow Function Syntax

All functions must use **arrow function syntax** instead of function declarations.

**Incorrect (function declaration syntax):**

```typescript
export function fetchUser(id: string) {
  return ky.get(`/api/users/${id}`).json()
}

function calculateTotal(items: Item[]) {
  return items.reduce((sum, item) => sum + item.price, 0)
}
```

**Correct (arrow functions):**

```typescript
export const fetchUser = async (id: string) => {
  return await ky.get(`/api/users/${id}`).json()
}

const calculateTotal = (items: Item[]) => {
  return items.reduce((sum, item) => sum + item.price, 0)
}
```

**Benefits:**

- Consistent code style across the codebase
- Lexical `this` binding (avoids common pitfalls)
- More concise syntax for simple functions

**Apply to:**

- Exported functions
- Internal utility functions
- Event handlers
- Callback functions
