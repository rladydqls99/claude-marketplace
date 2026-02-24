---
name: nest-exception
description: "Generate NestJS custom exceptions and global exception filter. Use when the user asks to create error handling, custom exceptions, or exception filters (e.g., '/nest-exception', '에러 처리 필터 만들어줘')."
---

# NestJS Exception & Filter Generator

## Global Exception Filter

```typescript
@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(GlobalExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let message = "서버 내부 오류가 발생했습니다";

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const res = exception.getResponse();
      message = typeof res === "string" ? res : (res as any).message;
    } else if (exception instanceof PrismaClientKnownRequestError) {
      const mapped = this.handlePrismaError(exception);
      status = mapped.status;
      message = mapped.message;
    }

    if (status >= 500) this.logger.error(exception);

    response.status(status).json({
      statusCode: status,
      message,
      timestamp: new Date().toISOString(),
    });
  }

  private handlePrismaError(e: PrismaClientKnownRequestError) {
    switch (e.code) {
      case "P2002": return { status: 409, message: "이미 존재하는 데이터입니다" };
      case "P2025": return { status: 404, message: "데이터를 찾을 수 없습니다" };
      default: return { status: 500, message: "데이터베이스 오류가 발생했습니다" };
    }
  }
}
```

## Custom Exception Example

```typescript
export class BusinessRuleException extends HttpException {
  constructor(message: string) {
    super({ statusCode: HttpStatus.UNPROCESSABLE_ENTITY, message, error: "Business Rule Violation" }, HttpStatus.UNPROCESSABLE_ENTITY);
  }
}
```

## Registration in main.ts

```typescript
app.useGlobalFilters(new GlobalExceptionFilter());
```

## Rules

- Never expose stack traces in production
- Log server errors (5xx), skip client errors (4xx)
- Consistent JSON error response format: `{ statusCode, message, timestamp }`
- Handle Prisma errors (P2002=unique, P2025=not found)
- Use NestJS built-in exceptions first, custom only when insufficient
