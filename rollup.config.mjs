import * as url from "url"
import alias from "@rollup/plugin-alias"
import resolve from "@rollup/plugin-node-resolve"

const __dirname = url.fileURLToPath(new URL(".", import.meta.url))

export default [
  {
    input: "app/assets/javascripts/controllers/hw_combobox_controller.js",
    output: [
      {
        name: "HotwireCombobox",
        file: "app/assets/javascripts/hotwire_combobox.umd.js",
        format: "umd",
        globals: {
          "@hotwired/stimulus": "Stimulus"
        }
      },
      {
        name: "HotwireCombobox",
        file: "app/assets/javascripts/hotwire_combobox.esm.js",
        format: "es",
        globals: {
          "@hotwired/stimulus": "Stimulus"
        }
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
