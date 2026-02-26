## Widget Creation Pattern

Widgets are complex UI blocks that compose multiple features and entities. They focus on layout and composition rather than business logic.

**Directory Structure:**

```
widgets/header/
├── ui/              # Widget UI components
├── lib/             # Utility functions (optional)
└── index.ts         # Public API barrel export
```

**Step-by-Step:**

1. Compose from multiple features and entities
2. Keep widgets focused on layout and composition
3. Avoid business logic (delegate to features)

**Example:**

```typescript
// widgets/header/ui/header.tsx
import { Logo } from '@shared'
import { Navigation } from '@features/navigation'
import { UserMenu } from '@features/user-menu'

export const Header = () => (
  <header className="border-b">
    <div className="container mx-auto flex items-center justify-between py-4">
      <Logo />
      <Navigation />
      <UserMenu />
    </div>
  </header>
)

// widgets/header/index.ts
export { Header } from './ui/header'
```

**Key Points:**

- Widgets can import from `shared`, `entities`, and `features` layers
- Focus on layout and composition, not business logic
- Typically used for complex UI sections (headers, sidebars, footers)
- Delegate user interactions to features
- Export only public API through `index.ts`

**Common Widget Examples:**

- Header / Navigation bar
- Sidebar
- Footer
- Dashboard sections
- Modal layouts
- Complex forms that combine multiple features
