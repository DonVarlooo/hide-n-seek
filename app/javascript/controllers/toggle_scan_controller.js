import { Controller } from "@hotwired/stimulus"

// Connects to 
export default class extends Controller {
  static targets = ["togglableElementScan", "togglableElementQuitScan"]

  connect() {
    console.log("toggle scan controller")
  }

  DisplayScan() {
    this.togglableElementScanTarget.classList.toggle("d-none");
    this.togglableElementQuitScanTarget.classList.toggle("d-none");
  }
}
