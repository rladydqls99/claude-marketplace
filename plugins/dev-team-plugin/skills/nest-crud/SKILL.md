---
name: nest-crud
description: "Generate a complete NestJS CRUD module from a Prisma model name. Use when the user asks to create a new resource, module, or CRUD endpoints (e.g., '/nest-crud Product', 'Product CRUD 만들어줘'). Creates module, controller, service, and DTOs following SOLID principles."
---

# NestJS CRUD Module Generator

Generate a complete CRUD module for a given Prisma model.

## File Structure

```
src/{model-name}/
├── {model-name}.module.ts
├── {model-name}.controller.ts
├── {model-name}.service.ts
└── dto/
    ├── create-{model-name}.dto.ts
    ├── update-{model-name}.dto.ts
    └── {model-name}-response.dto.ts
```

## Controller Pattern

```typescript
@Controller("{model-names}")
@UseGuards(JwtAuthGuard)
export class {Model}Controller {
  constructor(private readonly {model}Service: {Model}Service) {}

  @Post()
  async create(@Body() dto: Create{Model}Dto): Promise<{Model}ResponseDto> {
    return this.{model}Service.create(dto);
  }

  @Get()
  async findAll(@Query() pagination: PaginationDto): Promise<PaginatedResponseDto<{Model}ResponseDto>> {
    return this.{model}Service.findAll(pagination);
  }

  @Get(":id")
  async findOne(@Param("id", ParseIntPipe) id: number): Promise<{Model}ResponseDto> {
    return this.{model}Service.findOneOrThrow(id);
  }

  @Patch(":id")
  async update(@Param("id", ParseIntPipe) id: number, @Body() dto: Update{Model}Dto): Promise<{Model}ResponseDto> {
    return this.{model}Service.update(id, dto);
  }

  @Delete(":id")
  @HttpCode(HttpStatus.NO_CONTENT)
  async remove(@Param("id", ParseIntPipe) id: number): Promise<void> {
    return this.{model}Service.remove(id);
  }
}
```

## Service Pattern

```typescript
@Injectable()
export class {Model}Service {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: Create{Model}Dto): Promise<{Model}ResponseDto> {
    const {model} = await this.prisma.{model}.create({ data: dto });
    return this.toResponseDto({model});
  }

  async findAll(pagination: PaginationDto): Promise<PaginatedResponseDto<{Model}ResponseDto>> {
    const [items, total] = await Promise.all([
      this.prisma.{model}.findMany({
        skip: (pagination.page - 1) * pagination.limit,
        take: pagination.limit,
        orderBy: { createdAt: "desc" },
      }),
      this.prisma.{model}.count(),
    ]);
    return { items: items.map(this.toResponseDto), total, page: pagination.page, limit: pagination.limit };
  }

  async findOneOrThrow(id: number): Promise<{Model}ResponseDto> {
    const {model} = await this.prisma.{model}.findUnique({ where: { id } });
    if (!{model}) throw new NotFoundException(`{Model} with ID ${id} not found`);
    return this.toResponseDto({model});
  }

  async update(id: number, dto: Update{Model}Dto): Promise<{Model}ResponseDto> {
    await this.findOneOrThrow(id);
    const updated = await this.prisma.{model}.update({ where: { id }, data: dto });
    return this.toResponseDto(updated);
  }

  async remove(id: number): Promise<void> {
    await this.findOneOrThrow(id);
    await this.prisma.{model}.delete({ where: { id } });
  }

  private toResponseDto({model}: {Model}): {Model}ResponseDto {
    // Exclude sensitive fields, return safe response
    return {model};
  }
}
```

## Rules

- HTTP status: 200 GET/PATCH, 201 POST, 204 DELETE, 400/401/403/404/409
- No business logic in controllers
- All dependencies injected via constructor
- Use `select` in Prisma queries to avoid over-fetching
- Never return sensitive fields (password, tokens) in response DTOs
- JSDoc on all public service methods
