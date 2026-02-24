---
name: rn-form
description: Generate a React Native form using react-hook-form, zod, and Controller. Trigger when asked to create a form, input screen, or any UI that collects user input and requires validation. Use for login, registration, settings, and data-entry screens.
---

# RN Form

## Overview

Generates a type-safe RN form using zod for schema validation, react-hook-form with zodResolver, and Controller to wrap native TextInput components. Uses Controller (not register) because RN inputs are uncontrolled by default.

## Template

```tsx
import React from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
} from 'react-native';
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

// 1. Define schema
const schema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
});

type FormValues = z.infer<typeof schema>;

// 2. Component
const ExampleForm = () => {
  const {
    control,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: {
      email: '',
      password: '',
    },
  });

  const onSubmit = async (values: FormValues) => {
    // handle submission
  };

  return (
    <View style={styles.container}>
      {/* 3. Wrap each input in Controller */}
      <Controller
        control={control}
        name="email"
        render={({ field: { onChange, onBlur, value } }) => (
          <View style={styles.field}>
            <TextInput
              style={[styles.input, errors.email && styles.inputError]}
              onChangeText={onChange}
              onBlur={onBlur}
              value={value}
              placeholder="Email"
              keyboardType="email-address"
              autoCapitalize="none"
            />
            {errors.email && (
              <Text style={styles.errorText}>{errors.email.message}</Text>
            )}
          </View>
        )}
      />

      <Controller
        control={control}
        name="password"
        render={({ field: { onChange, onBlur, value } }) => (
          <View style={styles.field}>
            <TextInput
              style={[styles.input, errors.password && styles.inputError]}
              onChangeText={onChange}
              onBlur={onBlur}
              value={value}
              placeholder="Password"
              secureTextEntry
            />
            {errors.password && (
              <Text style={styles.errorText}>{errors.password.message}</Text>
            )}
          </View>
        )}
      />

      <TouchableOpacity
        style={styles.button}
        onPress={handleSubmit(onSubmit)}
        disabled={isSubmitting}
      >
        <Text style={styles.buttonText}>Submit</Text>
      </TouchableOpacity>
    </View>
  );
};

export default ExampleForm;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 24,
  },
  field: {
    marginBottom: 16,
  },
  input: {
    height: 48,
    borderWidth: 1,
    borderColor: '#CBD5E0',
    borderRadius: 8,
    paddingHorizontal: 12,
    fontSize: 16,
  },
  inputError: {
    borderColor: '#E53E3E',
  },
  errorText: {
    marginTop: 4,
    fontSize: 12,
    color: '#E53E3E',
  },
  button: {
    height: 48,
    backgroundColor: '#3182CE',
    borderRadius: 8,
    justifyContent: 'center',
    alignItems: 'center',
  },
  buttonText: {
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: '600',
  },
});
```

## Rules

- Always use `Controller`, never `register` — RN TextInput is not a DOM element
- `defaultValues` is required for every field; prevents uncontrolled-to-controlled warnings
- Schema defined outside the component at module level
- `FormValues` derived from schema via `z.infer<typeof schema>`
- Error messages come from zod schema, not hardcoded in JSX
- `disabled={isSubmitting}` on the submit button to prevent double submission
