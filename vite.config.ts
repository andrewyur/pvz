import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';

export default defineConfig({
  build: {
    target: "es2022"
  },
  plugins: [
    sveltekit(),
    {
      name: 'add-coop-coep',
      configureServer(server) {
        server.middlewares.use((req, res, next) => {
          res.setHeader('Cross-Origin-Opener-Policy', 'same-origin');
          res.setHeader('Cross-Origin-Embedder-Policy', 'require-corp');

          if (req.originalUrl.endsWith('.ext2')) {
            res.setHeader('Content-Type', 'application/octet-stream')
            res.setHeader('Accept-Ranges', 'bytes')
          }
          
          next();
        });
      }
    }
  ]
});
