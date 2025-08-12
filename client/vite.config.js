import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { resolve } from 'path';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  define: {
    // Expose environment variables to the client
    'process.env.REACT_APP_API_URL': JSON.stringify(process.env.REACT_APP_API_URL || ''),
  },
  resolve: {
    alias: {
      '@api': resolve(__dirname, 'src/api'),
      '@components': resolve(__dirname, 'src/components'),
      '@config': resolve(__dirname, 'src/config'),
      '@pages': resolve(__dirname, 'src/pages'),
      '@utils': resolve(__dirname, 'src/utils'),
      '@assets': resolve(__dirname, 'src/assets'),
    },
  },
});
