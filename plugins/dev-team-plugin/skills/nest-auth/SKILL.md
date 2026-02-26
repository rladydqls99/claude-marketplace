---
name: nest-auth
description: "Generate JWT authentication module set (Strategy, Guard, Service, Decorator). Use when the user asks to set up authentication, JWT login, or registration endpoints (e.g., '/nest-auth', 'JWT 인증 모듈 만들어줘')."
---

# NestJS JWT Auth Module Generator

## File Structure

```
src/auth/
├── auth.module.ts
├── auth.controller.ts
├── auth.service.ts
├── strategies/
│   └── jwt.strategy.ts
├── guards/
│   └── jwt-auth.guard.ts
├── decorators/
│   ├── public.decorator.ts
│   └── current-user.decorator.ts
└── dto/
    ├── login.dto.ts
    ├── register.dto.ts
    └── auth-response.dto.ts
```

## JWT Strategy

```typescript
@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private configService: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: configService.get<string>("JWT_SECRET"),
    });
  }

  async validate(payload: { sub: number; email: string }) {
    return { id: payload.sub, email: payload.email };
  }
}
```

## Auth Service

```typescript
@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
  ) {}

  async register(dto: RegisterDto): Promise<AuthResponseDto> {
    const exists = await this.prisma.user.findUnique({ where: { email: dto.email } });
    if (exists) throw new ConflictException("이미 존재하는 이메일입니다");
    const hashedPassword = await bcrypt.hash(dto.password, 10);
    const user = await this.prisma.user.create({ data: { ...dto, password: hashedPassword } });
    return this.generateTokenResponse(user);
  }

  async login(dto: LoginDto): Promise<AuthResponseDto> {
    const user = await this.prisma.user.findUnique({ where: { email: dto.email } });
    if (!user || !(await bcrypt.compare(dto.password, user.password))) {
      throw new UnauthorizedException("이메일 또는 비밀번호가 올바르지 않습니다");
    }
    return this.generateTokenResponse(user);
  }

  private generateTokenResponse(user: User): AuthResponseDto {
    const payload = { sub: user.id, email: user.email };
    return { accessToken: this.jwtService.sign(payload), user: { id: user.id, email: user.email, name: user.name } };
  }
}
```

## Auth Module

```typescript
@Module({
  imports: [
    JwtModule.registerAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        secret: config.get<string>("JWT_SECRET"),
        signOptions: { expiresIn: config.get<string>("JWT_EXPIRES_IN", "1h") },
      }),
    }),
    PassportModule,
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy],
  exports: [AuthService],
})
export class AuthModule {}
```

## Rules

- Never return password in any response
- Hash passwords with bcrypt (salt rounds: 10)
- JWT secret from environment variables only
- Validate token payload rigorously
- Use `@Public()` decorator for unauthenticated routes
