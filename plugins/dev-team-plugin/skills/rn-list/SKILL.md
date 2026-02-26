---
name: rn-list
description: Generate an optimized React Native FlatList component. Trigger when asked to render a list, feed, or scrollable collection of items. Use when performance matters: large datasets, infinite scroll, or frequently re-rendering list items.
---

# RN List

## Overview

Generates a performance-optimized FlatList with memoized callbacks, fixed-height layout optimization, and a React.memo-wrapped item component. Prevents unnecessary re-renders and enables windowed rendering.

## List Container Template

```tsx
import React, { useCallback } from 'react';
import { FlatList, StyleSheet, View } from 'react-native';
import { ExampleItem } from './ExampleItem';

const ITEM_HEIGHT = 72;

interface Item {
  id: string;
  // ...fields
}

interface Props {
  data: Item[];
}

const ExampleList = ({ data }: Props) => {
  const keyExtractor = useCallback((item: Item) => item.id, []);

  const renderItem = useCallback(
    ({ item }: { item: Item }) => <ExampleItem item={item} />,
    [],
  );

  const getItemLayout = useCallback(
    (_: unknown, index: number) => ({
      length: ITEM_HEIGHT,
      offset: ITEM_HEIGHT * index,
      index,
    }),
    [],
  );

  return (
    <FlatList
      data={data}
      keyExtractor={keyExtractor}
      renderItem={renderItem}
      getItemLayout={getItemLayout}
      removeClippedSubviews
      maxToRenderPerBatch={10}
      windowSize={5}
      initialNumToRender={10}
      contentContainerStyle={styles.content}
    />
  );
};

export default ExampleList;

const styles = StyleSheet.create({
  content: {
    paddingHorizontal: 16,
    paddingVertical: 8,
  },
});
```

## List Item Template

```tsx
import React, { memo } from 'react';
import { View, Text, StyleSheet } from 'react-native';

interface Props {
  item: Item;
}

const ExampleItem = memo(({ item }: Props) => {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>{item.title}</Text>
    </View>
  );
});

ExampleItem.displayName = 'ExampleItem';
export { ExampleItem };

const styles = StyleSheet.create({
  container: {
    height: 72,          // must match ITEM_HEIGHT
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
  },
  title: {
    fontSize: 16,
    color: '#1A202C',
  },
});
```

## Rules

- `keyExtractor` and `renderItem` always wrapped in `useCallback`
- `getItemLayout` only when all items have fixed, equal height; omit otherwise
- List item component always wrapped in `React.memo`; set `displayName`
- `ITEM_HEIGHT` constant defined at module level and shared between list and item
- Default FlatList perf props: `removeClippedSubviews`, `maxToRenderPerBatch={10}`, `windowSize={5}`, `initialNumToRender={10}`
