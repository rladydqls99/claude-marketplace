---
name: nest-dto
description: "Generate NestJS DTO set (Create, Update, Response) with class-validator decorators. Use when the user asks to create DTOs, request/response types, or validation schemas for a NestJS resource (e.g., '/nest-dto User', 'User DTO 만들어줘')."
---

# NestJS DTO Generator

Generate Create/Update/Response DTO set for a given entity.

## CreateDto Pattern

```typescript
export class Create{Model}Dto {
  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  name: string;

  @IsEmail()
  @IsNotEmpty()
  email: string;

  @IsString()
  @MinLength(8)
  @MaxLength(100)
  password: string;

  @IsOptional()
  @IsString()
  description?: string;
}
```

## UpdateDto Pattern

```typescript
export class Update{Model}Dto extends PartialType(Create{Model}Dto) {}
```

## ResponseDto Pattern

```typescript
export class {Model}ResponseDto {
  id: number;
  name: string;
  email: string;
  createdAt: Date;
  updatedAt: Date;
  // Never include: password, tokens, internal flags
}
```

## Common Validators

| Type | Decorators |
|------|-----------|
| string (required) | `@IsString() @IsNotEmpty()` |
| string (optional) | `@IsOptional() @IsString()` |
| email | `@IsEmail() @IsNotEmpty()` |
| password | `@IsString() @MinLength(8) @MaxLength(100)` |
| number | `@IsNumber() @IsPositive()` |
| enum | `@IsEnum(MyEnum)` |
| boolean | `@IsBoolean()` |
| date | `@IsDateString()` |
| array | `@IsArray() @ArrayMinSize(1)` |
| nested | `@ValidateNested() @Type(() => NestedDto)` |

## Rules

- Separate DTO per operation (Create, Update, Response)
- UpdateDto extends PartialType(CreateDto)
- Never expose sensitive fields in ResponseDto
- Korean validation messages: `@IsEmail({}, { message: '올바른 이메일을 입력해주세요' })`
