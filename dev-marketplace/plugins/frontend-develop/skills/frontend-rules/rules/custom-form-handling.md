## Form Handling Pattern

Combine React Hook Form with Zod for type-safe forms with automatic validation.

**Pattern:**

1. Define Zod schema for validation
2. Use `zodResolver` to integrate with React Hook Form
3. Handle submission with type-safe data
4. Display validation errors

**Example:**

```typescript
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { toast } from 'sonner'

// 1. Define validation schema
const formSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters'),
  email: z.string().email('Invalid email address'),
  age: z.number().min(18, 'Must be at least 18'),
})

// 2. Infer TypeScript type from schema
type FormData = z.infer<typeof formSchema>

export const UserForm = () => {
  // 3. Initialize form with Zod resolver
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting }
  } = useForm<FormData>({
    resolver: zodResolver(formSchema)
  })

  // 4. Handle submission with type-safe data
  const onSubmit = async (data: FormData) => {
    try {
      await saveUser(data)
      toast.success('User saved successfully')
    } catch (error) {
      toast.error('Failed to save user')
    }
  }

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <div>
        <input {...register('name')} />
        {errors.name && <span>{errors.name.message}</span>}
      </div>

      <div>
        <input {...register('email')} type="email" />
        {errors.email && <span>{errors.email.message}</span>}
      </div>

      <div>
        <input {...register('age', { valueAsNumber: true })} type="number" />
        {errors.age && <span>{errors.age.message}</span>}
      </div>

      <button type="submit" disabled={isSubmitting}>
        {isSubmitting ? 'Saving...' : 'Save'}
      </button>
    </form>
  )
}
```

**Key Points:**

- Always use Zod for schema validation
- Use `zodResolver` to integrate with React Hook Form
- Infer TypeScript types from Zod schemas
- Display validation errors inline
- Handle submission states (loading, success, error)
- Use toast notifications for user feedback

**Benefits:**

- Type-safe forms with runtime validation
- Single source of truth for validation rules
- Automatic error messages
- Better developer experience
- Prevents invalid data submission
