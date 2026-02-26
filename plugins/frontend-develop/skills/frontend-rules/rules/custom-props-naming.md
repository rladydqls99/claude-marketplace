## Component Props Naming Convention

Component prop types must always be named exactly **`Props`** (not `ComponentNameProps`, `ComponentProps`, etc.).

**Incorrect (custom prop type names):**

```typescript
interface ButtonProps {
  title: string
  onClick: () => void
}

interface ButtonComponentProps {
  title: string
  onClick: () => void
}

export const Button = ({ title, onClick }: ButtonProps) => {
  return (
    <button onClick={onClick}>
      {title}
    </button>
  )
}
```

**Correct (Props naming convention):**

```typescript
interface Props {
  title: string
  onClick: () => void
  className?: string
}

export const Button = ({ title, onClick, className }: Props) => {
  return (
    <button onClick={onClick} className={className}>
      {title}
    </button>
  )
}
```

**Benefits:**

- Consistent naming across all components
- Shorter, cleaner code
- Easier to identify component props at a glance
- Reduces naming conflicts (props are scoped to the component file)

**Apply to:**

- All React component prop interfaces
- Both exported and internal components
