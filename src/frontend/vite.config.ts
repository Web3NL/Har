import { defineConfig } from 'vite'
import { svelte } from '@sveltejs/vite-plugin-svelte'
import * as fs from 'fs'

const production = process.env["DFX_NETWORK"] === "ic"
const canisterIdsPath = production ? "../../canister_ids.json" : "../../.dfx/local/canister_ids.json"
const localIICanisterIdsPath = "../../internet-identity/.dfx/local/canister_ids.json"

const DFX_PORT = '8000'
const DFX_NETWORK = process.env.DFX_NETWORK || (process.env.NODE_ENV === "production" ? "ic" : "local");

type Network = "ic" | "local"

interface CanisterIdsJson {
  [key: string]: { [key in Network]: string }
}

let canisterIdsJson : CanisterIdsJson
let canisterIdsJsonII : CanisterIdsJson

try {
  canisterIdsJson = JSON.parse(
    fs.readFileSync(canisterIdsPath).toString()
  )
  canisterIdsJsonII = JSON.parse(
    fs.readFileSync(localIICanisterIdsPath).toString()
  )
} catch (e) {
  console.error("Failed to find or parse 'canister_ids.json'")
}

const canisterIds = Object.entries(canisterIdsJson).reduce(
  (canister, [key, val]) => ({
    ...canister,
    [`process.env.${key.toUpperCase()}_CANISTER_ID`]: production
      ? JSON.stringify(val.ic)
      : JSON.stringify(val.local),
  }),
  {}
)

const canisterIdsII = Object.entries(canisterIdsJsonII).reduce(
  (canister, [key, val]) => ({
    ...canister,
    [`process.env.${key.toUpperCase()}_CANISTER_ID`]: production
      ? JSON.stringify(val.ic)
      : JSON.stringify(val.local),
  }),
  {}
)

export default defineConfig({
  plugins: [svelte()],
  cacheDir: "../../node_modules/.vite",
  build: {
    target: 'esnext'
  },
  server: {
    proxy: {
      "/api": {
        target: `http://localhost:${DFX_PORT}`,
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, "/api"),
      },
    },
    // host: true,
  },
  define: {
    ...canisterIds,
    ...canisterIdsII,
    "process.env.NODE_ENV": JSON.stringify(production ? "production" : "development"),
    "process.env.DFX_NETWORK": JSON.stringify(DFX_NETWORK),
  }
})
