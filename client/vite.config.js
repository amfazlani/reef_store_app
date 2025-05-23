import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue()],
  optimizeDeps: {
    include: ['fast-deep-equal'],
  },
  transpile: ['@googlemaps/js-api-loader'],
})
