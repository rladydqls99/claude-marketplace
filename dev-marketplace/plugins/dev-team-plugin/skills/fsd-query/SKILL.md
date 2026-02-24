---
name: fsd-query
description: Generate TanStack Query hooks for a FSD slice (queryKeys, useQuery, useMutation with invalidation). Trigger when asked to create data-fetching hooks, query hooks, mutation hooks, or any useQuery/useMutation pattern in an FSD project.
---

# FSD Query

Generates TanStack Query hooks following the project's queryKeys pattern, using ky for HTTP.

## Rules

- Arrow functions only
- `queryKeys` object with `all` and `detail` (and optional sub-keys)
- `staleTime` on every `useQuery`
- `useMutation` always invalidates on `onSuccess`

## Template

**model/queries.ts**
```ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { {sliceName}Api } from '../api/{sliceName}Api'
import type { {SliceName}, Create{SliceName}Dto, Update{SliceName}Dto } from './types'

export const {sliceName}Keys = {
  all: ['{slice-name}'] as const,
  lists: () => [...{sliceName}Keys.all, 'list'] as const,
  detail: (id: string) => [...{sliceName}Keys.all, 'detail', id] as const,
}

export const use{SliceName}List = () =>
  useQuery({
    queryKey: {sliceName}Keys.lists(),
    queryFn: () => {sliceName}Api.getAll(),
    staleTime: 1000 * 60 * 5, // 5 minutes
  })

export const use{SliceName} = (id: string) =>
  useQuery({
    queryKey: {sliceName}Keys.detail(id),
    queryFn: () => {sliceName}Api.getById(id),
    staleTime: 1000 * 60 * 5,
    enabled: !!id,
  })

export const useCreate{SliceName} = () => {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: (data: Create{SliceName}Dto) => {sliceName}Api.create(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: {sliceName}Keys.lists() })
    },
  })
}

export const useUpdate{SliceName} = () => {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: Update{SliceName}Dto }) =>
      {sliceName}Api.update(id, data),
    onSuccess: (_, { id }) => {
      queryClient.invalidateQueries({ queryKey: {sliceName}Keys.detail(id) })
      queryClient.invalidateQueries({ queryKey: {sliceName}Keys.lists() })
    },
  })
}

export const useDelete{SliceName} = () => {
  const queryClient = useQueryClient()
  return useMutation({
    mutationFn: (id: string) => {sliceName}Api.delete(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: {sliceName}Keys.all })
    },
  })
}
```

## staleTime Reference

| Data freshness | staleTime |
|---|---|
| Realtime | `0` |
| Normal UI data | `1000 * 60 * 5` (5 min) |
| Static / rarely changes | `1000 * 60 * 30` (30 min) |
| Never refetch | `Infinity` |

## Invalidation Patterns

```ts
// Invalidate all queries for a slice
queryClient.invalidateQueries({ queryKey: {sliceName}Keys.all })

// Invalidate only list
queryClient.invalidateQueries({ queryKey: {sliceName}Keys.lists() })

// Invalidate single item + list
queryClient.invalidateQueries({ queryKey: {sliceName}Keys.detail(id) })
queryClient.invalidateQueries({ queryKey: {sliceName}Keys.lists() })
```
