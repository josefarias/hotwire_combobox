import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["clearLog"]

  connect() {
    this.clearCount = 0
  }

  onClear(event) {
    this.clearCount++

    const timestamp = new Date().toLocaleTimeString()
    const logEntry = [
      `[${timestamp}]`,
      `  Clear Event #${this.clearCount}:`,
      `  Previous Value: "${event.detail.previousValue || '<empty>'}"`,
      `  Previous Display: "${event.detail.previousDisplay || '<empty>'}"`,
      `  Field Name: "${event.detail.fieldName}"`,
      ""
    ].join("\n")

    if (this.clearCount === 1) {
      this.clearLogTarget.textContent = logEntry
    } else {
      this.clearLogTarget.textContent = logEntry + this.clearLogTarget.textContent
    }
  }

  clearLogs() {
    this.clearLogTarget.textContent = "No clear events yet. Type something and then click the × button."
    this.clearCount = 0
  }
}
