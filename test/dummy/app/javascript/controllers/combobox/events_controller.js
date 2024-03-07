import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "selectionScratchpad" ]

  connect() {
    this.selectionScratchpadTarget.innerText = "Ready to listen for hw-combobox events!"
  }

  showSelection(event) {
    this.selectionScratchpadTarget.innerText = this.#template(event)
  }

  #template(event) {
    return `event: ${String(event.type) || "<empty>"}
      value: ${String(event.detail.value) || "<empty>"}
      display: ${String(event.detail.display) || "<empty>"}
      query: ${String(event.detail.query) || "<empty>"}
      fieldName: ${String(event.detail.fieldName) || "<empty>"}
      isNew: ${String(event.detail.isNew) || "<empty>"}
      isValid: ${String(event.detail.isValid) || "<empty>"}
    `
  }
}
