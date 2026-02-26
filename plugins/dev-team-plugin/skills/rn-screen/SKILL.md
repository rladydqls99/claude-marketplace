---
name: rn-screen
description: Generate a React Native screen component with loading/error/empty states. Trigger when asked to create a screen, page, or view in a React Native app. Use when the request involves data fetching (useQuery), conditional UI states, or placing a component in the FSD pages/ layer.
---

# RN Screen

## Overview

Generates a React Native screen component following FSD architecture (pages/ layer), using useQuery for data fetching with proper loading, error, and empty state handling. StyleSheet properties are ordered: layout → spacing → visual → typography.

## Template

```tsx
// src/pages/ExampleScreen/ui/ExampleScreen.tsx
import React from 'react';
import { View, Text, ActivityIndicator, StyleSheet } from 'react-native';
import { useQuery } from '@tanstack/react-query';

interface Props {
  // navigation props if needed
}

const ExampleScreen = ({}: Props) => {
  const { data, isLoading, isError, error } = useQuery({
    queryKey: ['example'],
    queryFn: fetchExample,
  });

  if (isLoading) {
    return (
      <View style={styles.centered}>
        <ActivityIndicator size="large" />
      </View>
    );
  }

  if (isError) {
    return (
      <View style={styles.centered}>
        <Text style={styles.errorText}>{error.message}</Text>
      </View>
    );
  }

  if (!data || data.length === 0) {
    return (
      <View style={styles.centered}>
        <Text style={styles.emptyText}>No items found.</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      {/* main content */}
    </View>
  );
};

export default ExampleScreen;

const styles = StyleSheet.create({
  // layout
  container: {
    flex: 1,
  },
  centered: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  // spacing
  // visual
  // typography
  errorText: {
    color: '#E53E3E',
    fontSize: 14,
  },
  emptyText: {
    color: '#718096',
    fontSize: 14,
  },
});
```

## Rules

- Arrow function component, not `function` declaration
- FSD placement: `src/pages/<ScreenName>/ui/<ScreenName>.tsx`
- State order: loading → error → empty → success
- StyleSheet property order: layout (flex, position, width/height) → spacing (margin, padding) → visual (backgroundColor, borderRadius, shadow) → typography (fontSize, fontWeight, color)
- Export the component as `default`; re-export from `src/pages/<ScreenName>/index.ts`
