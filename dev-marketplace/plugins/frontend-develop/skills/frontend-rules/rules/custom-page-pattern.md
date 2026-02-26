## Page Creation Pattern

Pages are route-mapped components that compose widgets, features, and entities. They handle page-level state and data fetching.

**Directory Structure:**

```
pages/user-detail/
├── ui/              # Page UI components
└── index.ts         # Public API barrel export
```

**Step-by-Step:**

1. Create route file in `src/app/routes/`
2. Implement page component in `pages/` layer
3. Compose from widgets, features, entities
4. Handle page-level state and data fetching

**Example:**

```typescript
// pages/user-detail/ui/user-detail-page.tsx
import { UserProfile } from '@features/user-profile'
import { UserActivity } from '@features/user-activity'

interface Props {
  userId: string
}

export const UserDetailPage = ({ userId }: Props) => {
  return (
    <div className="container mx-auto py-8">
      <UserProfile userId={userId} />
      <UserActivity userId={userId} />
    </div>
  )
}

// pages/user-detail/index.ts
export { UserDetailPage } from './ui/user-detail-page'

// app/routes/users/$userId.tsx
import { createFileRoute } from '@tanstack/react-router'
import { UserDetailPage } from '@pages/user-detail'

export const Route = createFileRoute('/users/$userId')({
  component: () => {
    const { userId } = Route.useParams()
    return <UserDetailPage userId={userId} />
  }
})
```

**Key Points:**

- Pages can import from all layers (`shared`, `entities`, `features`, `widgets`)
- One page per route
- Focus on composition and layout
- Extract route params in the route file, pass to page component
- Keep business logic in features, not pages
- Pages are the final composition layer

**Common Patterns:**

- Extracting route parameters
- Composing multiple features
- Layout and structure
- Error boundaries
- Loading states
