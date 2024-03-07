import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "selectionScratchpad", "validityScratchpad" ]

  connect() {
    this.selectionScratchpadTarget.innerText = "Ready to listen for hw-combobox events!"
  }

  showSelection(event) {
    this.selectionScratchpadTarget.innerText = this.#template(event)
  }

  showValidity(event) {
    this.validityScratchpadTarget.innerText = this.#template(event)
  }

  #template(event) {
    return `event: ${event.type}
      value: ${event.detail.value}
      display: ${event.detail.display}
      query: ${event.detail.query}
      fieldName: ${event.detail.fieldName}
      isNew: ${event.detail.isNew}
    `
  }
}
