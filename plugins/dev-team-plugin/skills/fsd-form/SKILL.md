---
name: fsd-form
description: Generate a react-hook-form + zod form component for a FSD slice. Trigger when asked to create a form, form component, or any input/submit UI that needs validation in an FSD project.
---

# FSD Form

Generates a validated form component using zod schema, react-hook-form, and Tailwind styling.

## Rules

- Arrow functions only
- Zod schema → infer TypeScript type → pass to `zodResolver`
- Always show per-field error messages
- `cn()` for className with category ordering
- Submit calls a mutation hook; disable button while `isPending`

## Template

**ui/{SliceName}Form.tsx**
```tsx
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { cn } from '@/shared/lib/utils'
import { useCreate{SliceName} } from '../model/queries'

const {sliceName}Schema = z.object({
  name: z.string().min(1, '이름을 입력해주세요'),
  // ...add fields
})

type {SliceName}FormValues = z.infer<typeof {sliceName}Schema>

interface {SliceName}FormProps {
  onSuccess?: () => void
  className?: string
}

export const {SliceName}Form = ({ onSuccess, className }: {SliceName}FormProps) => {
  const { mutate: create, isPending } = useCreate{SliceName}()

  const {
    register,
    handleSubmit,
    formState: { errors },
    reset,
  } = useForm<{SliceName}FormValues>({
    resolver: zodResolver({sliceName}Schema),
  })

  const onSubmit = (values: {SliceName}FormValues) => {
    create(values, {
      onSuccess: () => {
        reset()
        onSuccess?.()
      },
    })
  }

  return (
    <form
      onSubmit={handleSubmit(onSubmit)}
      className={cn('flex flex-col gap-4', className)}
    >
      <div className="flex flex-col gap-1">
        <label className="text-sm font-medium text-gray-700">이름</label>
        <input
          {...register('name')}
          className={cn(
            'w-full px-3 py-2',
            'text-sm text-gray-900',
            'rounded-md border border-gray-300',
            'focus:outline-none focus:ring-2 focus:ring-blue-500',
            errors.name && 'border-red-500 focus:ring-red-500'
          )}
        />
        {errors.name && (
          <p className="text-xs text-red-500">{errors.name.message}</p>
        )}
      </div>

      <button
        type="submit"
        disabled={isPending}
        className={cn(
          'flex items-center justify-center',
          'px-4 py-2',
          'w-full',
          'text-sm font-medium text-white',
          'bg-blue-600 rounded-md',
          'hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed',
          'transition-colors'
        )}
      >
        {isPending ? '저장 중...' : '저장'}
      </button>
    </form>
  )
}
```

## Zod Patterns

```ts
// Common field validators
z.string().min(1, 'Required')
z.string().email('Invalid email')
z.number().min(0, 'Must be positive')
z.enum(['a', 'b', 'c'])
z.coerce.number()           // for <input type="number">
z.string().optional()
field: z.string().nullable()

// Refinement
.refine((val) => val !== 'forbidden', { message: 'Not allowed' })
.superRefine((data, ctx) => { /* cross-field validation */ })
```

## Edit Form Variant

```tsx
// Pre-populate with defaultValues
const { data } = use{SliceName}(id)

useForm<{SliceName}FormValues>({
  resolver: zodResolver({sliceName}Schema),
  defaultValues: data ? { name: data.name } : undefined,
})

// Use useUpdate{SliceName} mutation instead
const { mutate: update } = useUpdate{SliceName}()
const onSubmit = (values: {SliceName}FormValues) => update({ id, data: values })
```
