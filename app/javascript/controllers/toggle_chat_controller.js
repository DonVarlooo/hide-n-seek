import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-chat"
export default class extends Controller {
  static targets = ["togglableElementChat"]

  DisplayChat() {
    this.togglableElementChatTarget.classList.toggle("d-none");
  }
}
