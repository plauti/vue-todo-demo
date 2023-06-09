import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import config from "../../sfdxConfig.json";

// https://vitejs.dev/config/
export default defineConfig(({ command, mode }) => {
  let instanceUrl = "";
  if (command !== "build") {
    instanceUrl = config.result.instanceUrl;
  }

  return {
    define: {
      "import.meta.env.SF_INSTANCE_URL": `"${instanceUrl}"`
    },
    server: {
      proxy: {
        "/sfRestProxy": {
          target: `${config.result.instanceUrl}/services/apexrest/WebApiRestEntryPoint`,
          changeOrigin: true,
          secure: false,
          rewrite: (path) => path.replace(/^\/sfRestProxy/, ""),
          headers: {
            Authorization: `Bearer ${config.result.accessToken}`
          }
        }
      }
    },
    plugins: [vue()], // TODO: htmlPurge({ }) but take sficon into account
    build: {
      outDir: "../main/default/staticResources/frontend", // output compiled vue app to static resources
      assetsDir: "",
      sourcemap: false,
      rollupOptions: {
        output: {
          entryFileNames: "[name].js",
          assetFileNames: "[name].[ext]",
          manualChunks: {}
        }
      }
    },
    base: "",
    test: {
      globals: true,
      environment: "happy-dom"
    }
  };
});
