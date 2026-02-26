---
name: frontend-design
description: Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, or applications. Also use when setting visual direction, choosing a color system, or defining UI aesthetics. Generates creative, polished code that avoids generic AI aesthetics.
---

# Frontend Design Skill

This skill guides creation of distinctive, production-grade frontend interfaces that avoid generic "AI slop" aesthetics. Implement real working code with exceptional attention to aesthetic details and creative choices.

The user provides frontend requirements: a component, page, application, or interface to build. They may include context about the purpose, audience, or technical constraints.

## 프로젝트 스타일 파일 우선 감지

**코드 작성 전 반드시 먼저 수행:**

1. 프로젝트 루트 또는 `src/`, `app/`, `styles/` 폴더에서 아래 파일들을 탐색한다:
   - `global.css`, `globals.css`
   - `styles.css`, `style.css`
   - `tailwind.config.ts`, `tailwind.config.js`
   - `tokens.css`, `variables.css`, `theme.css`
   - `_variables.scss`, `_tokens.scss`

2. **파일이 존재하면:**
   - CSS 변수(--color-*, --bg-*, --text-* 등)를 추출해 색상 팔레트를 파악한다
   - 이미 정의된 폰트, 간격, 그림자 등 디자인 토큰을 그대로 활용한다
   - 새로운 색상을 임의로 추가하지 않고 기존 시스템을 확장하는 방향으로 설계한다
   - "기존 스타일 파일 기반으로 색상을 구성했습니다"라고 명시한다

3. **파일이 없으면:**
   - 아래 디자인 프로세스에 따라 새로운 색상 시스템을 직접 결정한다

---

## Design Thinking

Before coding, understand the context and commit to a BOLD aesthetic direction:

- **Purpose**: What problem does this interface solve? Who uses it?
- **Tone**: Pick an extreme: brutally minimal, maximalist chaos, retro-futuristic, organic/natural, luxury/refined, playful/toy-like, editorial/magazine, brutalist/raw, art deco/geometric, soft/pastel, industrial/utilitarian, etc. There are so many flavors to choose from. Use these for inspiration but design one that is true to the aesthetic direction.
- **Constraints**: Technical requirements (framework, performance, accessibility).
- **Differentiation**: What makes this UNFORGETTABLE? What's the one thing someone will remember?

**CRITICAL**: Choose a clear conceptual direction and execute it with precision. Bold maximalism and refined minimalism both work - the key is intentionality, not intensity.

Then implement working code (HTML/CSS/JS, React, Vue, etc.) that is:

- Production-grade and functional
- Visually striking and memorable
- Cohesive with a clear aesthetic point-of-view
- Meticulously refined in every detail

## Frontend Aesthetics Guidelines

Focus on:

- **Typography**: Choose fonts that are beautiful, unique, and interesting. Avoid generic fonts like Arial and Inter; opt instead for distinctive choices that elevate the frontend's aesthetics; unexpected, characterful font choices. Pair a distinctive display font with a refined body font.
- **Color & Theme**: Commit to a cohesive aesthetic. Use CSS variables for consistency. Dominant colors with sharp accents outperform timid, evenly-distributed palettes. **기존 global.css/styles.css가 있으면 해당 변수를 우선 사용한다.**
- **Motion**: Use animations for effects and micro-interactions. Prioritize CSS-only solutions for HTML. Use Motion library for React when available. Focus on high-impact moments: one well-orchestrated page load with staggered reveals (animation-delay) creates more delight than scattered micro-interactions. Use scroll-triggering and hover states that surprise.
- **Spatial Composition**: Unexpected layouts. Asymmetry. Overlap. Diagonal flow. Grid-breaking elements. Generous negative space OR controlled density.
- **Backgrounds & Visual Details**: Create atmosphere and depth rather than defaulting to solid colors. Add contextual effects and textures that match the overall aesthetic. Apply creative forms like gradient meshes, noise textures, geometric patterns, layered transparencies, dramatic shadows, decorative borders, custom cursors, and grain overlays.

NEVER use generic AI-generated aesthetics like overused font families (Inter, Roboto, Arial, system fonts), cliched color schemes (particularly purple gradients on white backgrounds), predictable layouts and component patterns, and cookie-cutter design that lacks context-specific character.

Interpret creatively and make unexpected choices that feel genuinely designed for the context. No design should be the same. Vary between light and dark themes, different fonts, different aesthetics. NEVER converge on common choices (Space Grotesk, for example) across generations.

**IMPORTANT**: Match implementation complexity to the aesthetic vision. Maximalist designs need elaborate code with extensive animations and effects. Minimalist or refined designs need restraint, precision, and careful attention to spacing, typography, and subtle details. Elegance comes from executing the vision well.

## 색상 구성 우선순위 요약

```
1순위: global.css / globals.css / styles.css / tailwind.config에 정의된 CSS 변수 사용
2순위: 프로젝트 내 토큰 파일(tokens.css, _variables.scss 등) 참고
3순위: 파일 없을 경우 → 아래 디자인 씽킹 기반으로 직접 CSS 변수 정의
```

## 출력 형식

```markdown
## 디자인 결정
- **기반**: [기존 스타일 파일 사용 / 새로 설계]
- **무드**: (한 문장)
- **색상 출처**: [global.css의 --primary 등 / 직접 정의]
- **차별점**: (1-2가지)

## 구현
(완전한 실행 가능 코드)
```

## 금지 사항

- HEX 코드만 수십 줄 나열하는 색상표
- 모든 브레이크포인트/접근성/애니메이션을 무조건 포함
- 프로젝트 맥락 없이 범용 디자인 시스템 복붙
- "[예: ...]", "[색상명]" 같은 빈칸 템플릿
- 기존 global.css가 있는데 무시하고 새 색상 시스템 강제 적용

## 작성 원칙

- 모든 출력은 한국어 설명, 코드는 영어
- 짧고 결정적인 문장 사용 (설명이 아니라 결정을 내린다)
- 코드 예시는 Tailwind CSS 기준으로 제공
- 프로젝트에 이미 있는 설정과 충돌하지 않도록 기존 코드를 먼저 확인

Remember: Claude is capable of extraordinary creative work. Don't hold back, show what can truly be created when thinking outside the box and committing fully to a distinctive vision.
