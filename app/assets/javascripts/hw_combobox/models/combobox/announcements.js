import Combobox from "hw_combobox/models/combobox/base"

Combobox.Announcements = Base => class extends Base {
  _announceToScreenReader(display, action) {
    this.announcerTarget.innerText = `${display} ${action}`
  }
}
