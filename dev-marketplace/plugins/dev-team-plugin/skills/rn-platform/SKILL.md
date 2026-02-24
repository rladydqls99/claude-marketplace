---
name: rn-platform
description: Generate platform-specific React Native components using .ios.tsx and .android.tsx file extensions. Trigger when asked to create a component that behaves or looks differently on iOS vs Android, or when following platform design guidelines (HIG for iOS, Material Design 3 for Android).
---

# RN Platform

## Overview

Generates paired `.ios.tsx` / `.android.tsx` files that Metro bundler resolves automatically at build time. iOS follows Apple Human Interface Guidelines; Android follows Material Design 3. No runtime `Platform.OS` branching needed.

## File Structure

```
src/shared/ui/ExampleButton/
  ExampleButton.ios.tsx      ← loaded on iOS
  ExampleButton.android.tsx  ← loaded on Android
  index.ts                   ← re-exports shared type
  types.ts                   ← shared prop interface
```

## Shared Types (`types.ts`)

```tsx
export interface ExampleButtonProps {
  label: string;
  onPress: () => void;
  disabled?: boolean;
}
```

## iOS Template (`ExampleButton.ios.tsx`)

```tsx
// Follows Apple HIG
import React from 'react';
import { TouchableOpacity, Text, StyleSheet } from 'react-native';
import type { ExampleButtonProps } from './types';

const ExampleButton = ({ label, onPress, disabled }: ExampleButtonProps) => (
  <TouchableOpacity
    style={[styles.button, disabled && styles.disabled]}
    onPress={onPress}
    disabled={disabled}
    activeOpacity={0.7}
    hitSlop={{ top: 8, bottom: 8, left: 8, right: 8 }}
  >
    <Text style={styles.label}>{label}</Text>
  </TouchableOpacity>
);

export default ExampleButton;

const styles = StyleSheet.create({
  // layout
  button: {
    minWidth: 44,
    minHeight: 44,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 20,
    // visual — iOS: rounded rect, system blue
    backgroundColor: '#007AFF',
    borderRadius: 10,
  },
  disabled: {
    opacity: 0.4,
  },
  // typography — iOS: SF Pro weight semibold
  label: {
    fontSize: 17,
    fontWeight: '600',
    color: '#FFFFFF',
  },
});
```

## Android Template (`ExampleButton.android.tsx`)

```tsx
// Follows Material Design 3
import React from 'react';
import { Pressable, Text, StyleSheet } from 'react-native';
import type { ExampleButtonProps } from './types';

const ExampleButton = ({ label, onPress, disabled }: ExampleButtonProps) => (
  <Pressable
    style={({ pressed }) => [
      styles.button,
      pressed && styles.pressed,
      disabled && styles.disabled,
    ]}
    onPress={onPress}
    disabled={disabled}
    android_ripple={{ color: 'rgba(255,255,255,0.24)', borderless: false }}
    hitSlop={{ top: 8, bottom: 8, left: 8, right: 8 }}
  >
    <Text style={styles.label}>{label}</Text>
  </Pressable>
);

export default ExampleButton;

const styles = StyleSheet.create({
  // layout
  button: {
    minWidth: 44,
    minHeight: 44,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 24,
    // visual — MD3: filled button, full radius pill
    backgroundColor: '#6750A4',
    borderRadius: 100,
    elevation: 2,
  },
  pressed: {
    elevation: 1,
  },
  disabled: {
    opacity: 0.38,
  },
  // typography — Android: Roboto Medium
  label: {
    fontSize: 14,
    fontWeight: '500',
    color: '#FFFFFF',
    letterSpacing: 0.1,
  },
});
```

## Barrel Export (`index.ts`)

```ts
export { default } from './ExampleButton';
export type { ExampleButtonProps } from './types';
```

## Rules

- Minimum touch target: 44x44pt; add `hitSlop` for visually smaller targets
- iOS: `TouchableOpacity` with `activeOpacity`, rounded rect (radius 10), SF Pro semibold, system blue `#007AFF`
- Android: `Pressable` with `android_ripple`, pill radius (100), elevation for depth, Roboto Medium
- Never use `Platform.OS` inside a platform-specific file
- Shared prop interface in `types.ts`; both files import from it
- Barrel `index.ts` exports the default — consumers import without knowing the platform
