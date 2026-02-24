---
name: nest-prisma
description: "Generate Prisma schema model with relations, indices, and constraints. Use when the user asks to add a database model, define schema, or set up relations (e.g., '/nest-prisma Order', 'Order 모델 추가해줘')."
---

# Prisma Schema Model Generator

## Model Template

```prisma
model {Model} {
  id        Int      @id @default(autoincrement())
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  // Fields
  name      String   @db.VarChar(100)
  email     String   @unique
  status    Status   @default(ACTIVE)

  // Relations
  posts     Post[]
  profile   Profile? @relation(fields: [profileId], references: [id])
  profileId Int?     @unique

  // Indices
  @@index([email])
  @@index([status, createdAt])
  @@map("users")
}

enum Status {
  ACTIVE
  INACTIVE
  SUSPENDED
}
```

## Relation Patterns

| Relation | Pattern |
|----------|---------|
| 1:1 | `profile Profile? @relation(fields: [profileId], references: [id])` + `profileId Int? @unique` |
| 1:N | Parent: `posts Post[]` / Child: `author User @relation(fields: [authorId], references: [id])` + `authorId Int` |
| M:N (implicit) | `tags Tag[]` on both sides |
| M:N (explicit) | Join table with two `@relation` fields |
| Self-relation | `parent Model? @relation("Tree", fields: [parentId], references: [id])` |

## Best Practices

- `@map("snake_case")` for table/column names
- `@@index` for frequently queried fields
- `@unique` for business-unique fields
- Soft delete: `deletedAt DateTime?` with `@@index([deletedAt])`
- Use `$transaction` for multi-step mutations
- Handle `PrismaClientKnownRequestError` for constraint violations (P2002 = unique, P2025 = not found)
