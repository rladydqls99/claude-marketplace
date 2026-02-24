---
name: fsd-slice
description: Generate a complete FSD slice directory structure for features, entities, or widgets layers. Trigger when asked to create a new slice, feature, entity, or widget in an FSD project, or when scaffolding a new module under src/features/, src/entities/, or src/widgets/.
---

# FSD Slice

Scaffolds the full FSD slice structure: `ui/`, `model/`, `api/`, `lib/`, and `index.ts`.

## Rules

- Arrow functions only (no `function` keyword)
- `cn()` for className composition with category ordering: layout → spacing → sizing → typography → color → border → effect
- Tech stack: React/Next.js, TanStack Query, Tailwind CSS, ky

## Directory Structure

```
src/{layer}/{slice-name}/
  ui/
    {SliceName}.tsx       # main component
    index.ts              # re-exports
  model/
    types.ts              # TypeScript interfaces/types
    store.ts              # local state (zustand) if needed
    index.ts
  api/
    {sliceName}Api.ts     # ky-based API calls
    index.ts
  lib/
    utils.ts              # slice-specific helpers
    index.ts
  index.ts                # public API (barrel export)
```

## Templates

**ui/{SliceName}.tsx**
```tsx
import { cn } from '@/shared/lib/utils'

interface {SliceName}Props {
  className?: string
}

export const {SliceName} = ({ className }: {SliceName}Props) => {
  return (
    <div className={cn('flex flex-col', className)}>
      {/* content */}
    </div>
  )
}
```

**model/types.ts**
```ts
export interface {SliceName} {
  id: string
  // ...fields
}
```

**api/{sliceName}Api.ts**
```ts
import ky from 'ky'

export const {sliceName}Api = {
  getAll: () => ky.get('/api/{slice-name}').json<{SliceName}[]>(),
  getById: (id: string) => ky.get(`/api/{slice-name}/${id}`).json<{SliceName}>(),
  create: (data: Create{SliceName}Dto) => ky.post('/api/{slice-name}', { json: data }).json<{SliceName}>(),
  update: (id: string, data: Update{SliceName}Dto) => ky.patch(`/api/{slice-name}/${id}`, { json: data }).json<{SliceName}>(),
  delete: (id: string) => ky.delete(`/api/{slice-name}/${id}`).json<void>(),
}
```

**index.ts (public API)**
```ts
export { {SliceName} } from './ui/{SliceName}'
export type { {SliceName} as {SliceName}Type } from './model/types'
export { {sliceName}Api } from './api/{sliceName}Api'
```

## cn() Category Ordering

```tsx
// layout → spacing → sizing → typography → color → border → effect
className={cn(
  'flex items-center',           // layout
  'px-4 py-2 gap-2',            // spacing
  'w-full h-10',                 // sizing
  'text-sm font-medium',         // typography
  'text-gray-900 bg-white',      // color
  'rounded-md border',           // border
  'shadow-sm hover:shadow-md',   // effect
  className
)}
```
