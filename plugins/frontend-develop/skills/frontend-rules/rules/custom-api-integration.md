## API Integration Pattern

Consistent pattern for API calls with Ky, Zod validation, React Query, and error handling.

**Pattern:**

1. Define API functions in entity/feature `api/` folder using Ky
2. Validate responses with Zod schemas
3. Create React Query hooks in `model/` folder
4. Handle errors and loading states
5. Show user feedback with toast notifications

**Example:**

```typescript
// In entities/user/api/
import ky from 'ky'
import { userSchema } from '../model/types'

export const fetchUsers = async () => {
  const response = await ky.get('/api/users').json()
  return z.array(userSchema).parse(response)
}

export const createUser = async (data: CreateUserInput) => {
  const response = await ky.post('/api/users', { json: data }).json()
  return userSchema.parse(response)
}

export const updateUser = async (id: string, data: UpdateUserInput) => {
  const response = await ky.patch(`/api/users/${id}`, { json: data }).json()
  return userSchema.parse(response)
}

export const deleteUser = async (id: string) => {
  await ky.delete(`/api/users/${id}`)
}

// In features/users/model/
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { toast } from 'sonner'
import { fetchUsers, createUser, updateUser, deleteUser } from '@entities/user/api'

export const useUsers = () => {
  return useQuery({
    queryKey: ['users'],
    queryFn: fetchUsers
  })
}

export const useCreateUser = () => {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: createUser,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] })
      toast.success('User created successfully')
    },
    onError: (error) => {
      toast.error('Failed to create user')
      console.error(error)
    }
  })
}

export const useUpdateUser = () => {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: UpdateUserInput }) =>
      updateUser(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] })
      toast.success('User updated successfully')
    },
    onError: (error) => {
      toast.error('Failed to update user')
      console.error(error)
    }
  })
}

export const useDeleteUser = () => {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: deleteUser,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] })
      toast.success('User deleted successfully')
    },
    onError: (error) => {
      toast.error('Failed to delete user')
      console.error(error)
    }
  })
}
```

**Key Points:**

- Use Ky for HTTP requests (modern fetch wrapper)
- Always validate API responses with Zod schemas
- Separate API functions (entities/api) from hooks (features/model)
- Use React Query for caching and state management
- Invalidate queries after mutations
- Show toast notifications for user feedback
- Log errors to console for debugging
- Handle loading states in components

**Benefits:**

- Type-safe API calls
- Automatic caching and deduplication
- Consistent error handling
- Better user experience with loading states
- Centralized API logic
