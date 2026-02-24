---
name: fsd-page
description: Generate a Next.js page component with loading, error, and empty states using TanStack Query. Trigger when asked to create a page, route component, or screen in an FSD project under src/pages/ or app/.
---

# FSD Page

Generates a Next.js page component that handles all async data states: loading, error, empty, and content.

## Rules

- Arrow functions only
- State order: `isLoading` → `isError` → `!data || data.length === 0` → content
- Page component lives in `src/pages/{page-name}/ui/{PageName}Page.tsx`
- Use inline fallback components (LoadingSpinner, ErrorView, EmptyState) unless shared ones exist

## Template

**ui/{PageName}Page.tsx**
```tsx
'use client'

import { cn } from '@/shared/lib/utils'
import { use{SliceName}List } from '@/features/{slice-name}'

export const {PageName}Page = () => {
  const { data, isLoading, isError } = use{SliceName}List()

  if (isLoading) {
    return (
      <div className="flex items-center justify-center w-full h-64">
        <div className="w-8 h-8 border-4 border-blue-500 border-t-transparent rounded-full animate-spin" />
      </div>
    )
  }

  if (isError) {
    return (
      <div className="flex flex-col items-center justify-center w-full h-64 gap-2">
        <p className="text-sm font-medium text-red-600">데이터를 불러오지 못했습니다</p>
        <p className="text-xs text-gray-500">잠시 후 다시 시도해주세요</p>
      </div>
    )
  }

  if (!data || data.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center w-full h-64 gap-2">
        <p className="text-sm font-medium text-gray-600">항목이 없습니다</p>
        <p className="text-xs text-gray-400">새 항목을 추가해보세요</p>
      </div>
    )
  }

  return (
    <main className={cn('flex flex-col', 'px-4 py-6 gap-6', 'w-full max-w-4xl mx-auto')}>
      <header className="flex items-center justify-between">
        <h1 className="text-xl font-bold text-gray-900">{PageName}</h1>
        {/* actions */}
      </header>

      <section className="flex flex-col gap-3">
        {data.map((item) => (
          <div key={item.id} className={cn('flex items-center', 'px-4 py-3', 'rounded-lg border border-gray-200', 'bg-white')}>
            {/* item content */}
          </div>
        ))}
      </section>
    </main>
  )
}
```

## Next.js App Router Integration

**app/{route}/page.tsx**
```tsx
import { {PageName}Page } from '@/pages/{page-name}'

export default function Page() {
  return <{PageName}Page />
}
```

**pages/index.ts (barrel export)**
```ts
export { {PageName}Page } from './ui/{PageName}Page'
```

## State Variants

```tsx
// Single item page (detail view)
const { data: item, isLoading, isError } = use{SliceName}(id)
if (!item) return <EmptyState message="항목을 찾을 수 없습니다" />

// Paginated list
const { data, isLoading, isError, fetchNextPage, hasNextPage } = use{SliceName}InfiniteList()
const items = data?.pages.flatMap((p) => p.items) ?? []
```
