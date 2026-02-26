## Entity Creation Pattern

Entities represent domain models in the FSD architecture. Follow this structure when creating entities.

**Directory Structure:**

```
entities/user/
├── ui/              # UI components
├── model/           # Types and schemas
├── api/             # API functions
├── lib/             # Utility functions (optional)
└── index.ts         # Public API barrel export
```

**Step-by-Step:**

1. Define types and Zod schemas in `model/`
2. Create API functions in `api/` using Ky
3. Build UI components in `ui/`
4. Export public API through `index.ts`

**Example:**

```typescript
// entities/user/model/types.ts
import { z } from 'zod'

export const userSchema = z.object({
  id: z.string(),
  name: z.string(),
  email: z.string().email(),
})

export type User = z.infer<typeof userSchema>

// entities/user/api/fetch-user.ts
import ky from 'ky'
import { userSchema } from '../model/types'

export const fetchUser = async (id: string) => {
  const response = await ky.get(`/api/users/${id}`).json()
  return userSchema.parse(response)
}

// entities/user/ui/user-card.tsx
import type { User } from '../model/types'

interface Props {
  user: User
}

export const UserCard = ({ user }: Props) => (
  <div className="rounded-lg border p-4">
    <h3>{user.name}</h3>
    <p>{user.email}</p>
  </div>
)

// entities/user/index.ts
export { UserCard } from './ui/user-card'
export { fetchUser } from './api/fetch-user'
export type { User } from './model/types'
```

**Key Points:**

- Entities can only import from the `shared` layer
- No business logic in entities (use features for that)
- Always validate API responses with Zod schemas
- Export only what other layers need through `index.ts`
