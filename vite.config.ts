import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import { nodePolyfills } from "vite-plugin-node-polyfills";

export default defineConfig({
  build: {
    target: "esnext",
  },
  plugins: [
    RubyPlugin(),
    nodePolyfills({
      include: ["buffer"],
      globals: {
        Buffer: true,
      },
    }),
  ],
});
