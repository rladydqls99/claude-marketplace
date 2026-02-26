## Feature Creation Pattern

Features represent user actions and business logic in the FSD architecture. They compose entities and shared components.

**Directory Structure:**

```
features/user-profile/
├── ui/              # Feature UI components
├── model/           # Business logic, hooks
├── api/             # Feature-specific API calls (optional)
├── lib/             # Utility functions (optional)
└── index.ts         # Public API barrel export
```

**Step-by-Step:**

1. Implement business logic in `model/` with React Query hooks
2. Build feature UI in `ui/` using entities and shared components
3. Handle forms with React Hook Form + Zod validation
4. Connect to backend via `api/` functions

**Example:**

```typescript
// features/user-profile/model/use-user.ts
import { useQuery } from '@tanstack/react-query'
import { fetchUser } from '@entities/user'

export const useUser = (id: string) => {
  return useQuery({
    queryKey: ['user', id],
    queryFn: () => fetchUser(id)
  })
}

// features/user-profile/ui/user-profile.tsx
import { UserCard } from '@entities/user'
import { useUser } from '../model/use-user'

interface Props {
  userId: string
}

export const UserProfile = ({ userId }: Props) => {
  const { data: user, isLoading } = useUser(userId)

  if (isLoading) return <div>Loading...</div>

  return <UserCard user={user} />
}

// features/user-profile/index.ts
export { UserProfile } from './ui/user-profile'
export { useUser } from './model/use-user'
```

**Key Points:**

- Features can import from `shared` and `entities` layers
- Business logic belongs in features, not entities
- Use React Query for data fetching and caching
- Handle user interactions and state management
- Export only public API through `index.ts`
