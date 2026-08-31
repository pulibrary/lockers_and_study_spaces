import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    include: ['spec/javascript/**/*.spec.js'],
    environment: 'jsdom',
  },
})
