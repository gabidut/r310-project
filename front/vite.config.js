import { defineConfig } from 'vite';

export default defineConfig({
    server: {
        proxy: {
            '/back': {
                target: 'http://localhost:8000',
                changeOrigin: true,
                rewrite: (path) => path.replace(/^\/back/, '')
            }
        }
    }
});
