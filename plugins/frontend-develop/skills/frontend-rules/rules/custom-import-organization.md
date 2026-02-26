## Import Organization

Imports should be organized in a specific order for consistency and readability (enforced by ESLint).

**Order:**

1. External dependencies (React, libraries)
2. Internal absolute imports (using @ aliases)
3. Relative imports
4. Type imports (if not inlined)

**Example:**

```typescript
// 1. External dependencies
import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { format } from 'date-fns'

// 2. Internal absolute imports (@ aliases)
import { Button } from '@shared'
import { UserCard } from '@entities/user'
import { SearchFeature } from '@features/city-search'

// 3. Relative imports
import { formatUserName } from './lib/format'
import { UserAvatar } from './ui/user-avatar'

// 4. Type imports (if not inlined)
import type { User } from './model/types'
```

**Benefits:**

- Consistent structure across all files
- Easy to locate specific imports
- Reduces merge conflicts
- Automatic formatting via ESLint

**Note:**

This rule is enforced by ESLint configuration. Running `pnpm lint:fix` will automatically organize imports according to this pattern.
