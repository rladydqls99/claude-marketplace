---
name: fsd-widget
description: Generate a Widget layer component (self-contained UI block like Header, Sidebar, Navbar, Dashboard panel) that composes features and entities. Trigger when asked to create a widget, header, sidebar, or any independent UI block in an FSD project under src/widgets/.
---

# FSD Widget

Generates a Widget layer component: a self-contained, independent UI block that composes features and entities.

## Rules

- Arrow functions only
- `cn()` for className with category ordering
- Widgets import from features/entities via public API (barrel exports) only — never from internal paths
- No direct API calls in widgets; use query hooks from features/entities
- Widget exposes a single named export via `index.ts`

## Directory Structure

```
src/widgets/{widget-name}/
  ui/
    {WidgetName}.tsx
    index.ts
  index.ts
```

## Template

**ui/{WidgetName}.tsx**
```tsx
'use client'

import { cn } from '@/shared/lib/utils'
// Import from feature/entity public APIs only
import { {FeatureName} } from '@/features/{feature-name}'
import { use{EntityName}List } from '@/entities/{entity-name}'

interface {WidgetName}Props {
  className?: string
}

export const {WidgetName} = ({ className }: {WidgetName}Props) => {
  return (
    <aside
      className={cn(
        'flex flex-col',
        'p-4 gap-4',
        'w-64 h-full',
        'bg-white',
        'border-r border-gray-200',
        className
      )}
    >
      {/* Widget content composed from features/entities */}
      <{FeatureName} />
    </aside>
  )
}
```

**index.ts**
```ts
export { {WidgetName} } from './ui/{WidgetName}'
export { {WidgetName} } from './ui/index'
```

## Common Widget Patterns

**Header widget**
```tsx
export const Header = ({ className }: { className?: string }) => (
  <header className={cn('flex items-center justify-between', 'px-6 h-14', 'w-full', 'bg-white', 'border-b border-gray-200', className)}>
    <Logo />
    <Navigation />
    <UserMenu />
  </header>
)
```

**Sidebar widget**
```tsx
export const Sidebar = ({ className }: { className?: string }) => {
  const { data: items } = useEntityList()
  return (
    <nav className={cn('flex flex-col', 'p-3 gap-1', 'w-60 h-full', 'bg-gray-50', 'border-r border-gray-200', className)}>
      {items?.map((item) => <SidebarItem key={item.id} item={item} />)}
    </nav>
  )
}
```

## Layer Import Rules

```
widgets  → can import from: features, entities, shared
features → can import from: entities, shared
entities → can import from: shared
shared   → no imports from upper layers
```

Widgets must NOT import from `pages` or other `widgets`.
