import * as url from "url"
import alias from "@rollup/plugin-alias"
import resolve from "@rollup/plugin-node-resolve"
import config from "./package.json" with { type: "json" }

const __dirname = url.fileURLToPath(new URL(".", import.meta.url))
const banner = `/*!\nHotwireCombobox ${config.version}\n*/`

export default [
  {
    input: "app/assets/javascripts/controllers/hw_combobox_controller.js",
    output: [
      {
        name: "HotwireCombobox",
        file: "app/assets/javascripts/hotwire_combobox.esm.js",
        format: "es",
        globals: {
          "@hotwired/stimulus": "Stimulus"
        },
        banner
      }
    ],
    plugins: [
      alias({
        entries: {
          "hw_combobox": `${__dirname}/app/assets/javascripts/hw_combobox`,
        }
      }),
      resolve()
    ],
    external: [
      "@hotwired/stimulus"
    ],
    watch: {
      include: "app/assets/javascripts/**"
    }
  }
]
